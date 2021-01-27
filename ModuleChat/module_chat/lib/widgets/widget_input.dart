
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/config/config_style.dart';
import 'package:module_chat/cores/chat_bloc.dart';
import 'package:module_chat/utils/take_files/core_file_datasource.dart';

class WidgetInputChat extends StatefulWidget {
  final BuildContext buildContext;
  final bool isShowDialog;
  final Function callFunctionScrollList;
  final Function callFunctionShowDialog;

  const WidgetInputChat(
      {Key key,
      this.buildContext,
      this.isShowDialog,
      this.callFunctionShowDialog,
      this.callFunctionScrollList})
      : super(key: key);

  @override
  _WidgetInputChatState createState() => _WidgetInputChatState();
}

class _WidgetInputChatState extends State<WidgetInputChat> {
  TextEditingController messageInput = new TextEditingController();
  bool isShowDialog=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if(widget.isShowDialog!=null){
      isShowDialog=widget.isShowDialog;
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: StyleColor.inputChatBackgroundColor,
            ),
            child: Center(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {
                        isShowDialog=!isShowDialog;
                      });
                      widget.callFunctionShowDialog?.call(isShowDialog);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(right: 10.0, top: 5.0, bottom: 5.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: !isShowDialog?Color(0xffe4eaf2):Color(0xff2f75b5)),
                      child: Icon( !isShowDialog? Icons.add:Icons.clear,
                      color: !isShowDialog?Colors.black:Colors.white,),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      onTap: (){
                        setState(() {
                          isShowDialog=false;
                        });
                        widget.callFunctionShowDialog?.call(false);

                      },
                      controller: messageInput,
                      maxLines: 5,
                      minLines: 1,
                      style: TextStyle(color: Color(0xff051a39)),
                      decoration: InputDecoration(
                        hintText: "Nhập nội dung tin nhắn",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        (messageInput.text != null && messageInput.text.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xff2f75b5)),
                  child: IconButton(
                    onPressed: () async {
                      await CheckSpace(messageInput.text);

                      if (messageInput.text != null &&
                          messageInput.text != " " &&
                          messageInput.text != "") {
                        BlocProvider.of<ChatBloc>(widget.buildContext)
                            .onTextChanged
                            .add(messageInput.text);
                        widget.callFunctionScrollList?.call();
                        setState(() {
                          messageInput.clear();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GestureDetector(
                    onTap: () {
                      getIt.get<CoreFileDataSource>().takePhoto(
                          context: context,
                          callBack: (dynamic param) {
                            BlocProvider.of<ChatBloc>(widget.buildContext)
                                .onTextChanged
                                .add(param);
                          });
                    },
                    child: Image(
                      image: AssetImage("images/input_camera.png"),
                      height: 34,
                      width: 38,
                    )),
              )
      ],
    );
  }

  Future<void> CheckSpace(String str) async {
    String _str;
    if (str != null && str.length > 0) {
      var indexLastSpace = str.indexOf(" ");
      if (indexLastSpace == 0 && str.length > 1) {
        _str = str.substring(1);
        CheckSpace(_str);
      } else {
        messageInput.text = str;
      }
    }
  }
}
