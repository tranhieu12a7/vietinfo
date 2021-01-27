import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/config/config_style.dart';
import 'package:module_chat/cores/chat_bloc.dart';
import 'package:module_chat/utils/take_files/core_file_datasource.dart';


class WidgetDialogChoose extends StatefulWidget {
  final BuildContext buildContext;
  final Function callFunctionTurnShowDialog;

  const WidgetDialogChoose({Key key, this.buildContext,this.callFunctionTurnShowDialog}) : super(key: key);

  @override
  _WidgetDialogChooseState createState() => _WidgetDialogChooseState();
}

class _WidgetDialogChooseState extends State<WidgetDialogChoose> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width/50;
    double height=MediaQuery.of(context).size.height/2;

    return Padding(
      padding:  EdgeInsets.only(top:height,bottom: 10, left: width,right: width),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                widget.callFunctionTurnShowDialog?.call(false);
                getIt.get<CoreFileDataSource>().takeAlbums(context: context,callBack: (dynamic param) {
                  BlocProvider.of<ChatBloc>(widget.buildContext)
                      .onTextChanged
                      .add(param);
                });

              },
              child: Row(
                children: [
                  Icon(Icons.image,size: 40,),
                  SizedBox(width: 10,),
                  Expanded(child: Text("Album Ảnh",style: TextStyle(
                    fontFamily: StyleFontFamily.SarabunMedium,
                    fontSize: StyleFontSize.fontSizeTitleDefault
                  ),)),
                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                widget.callFunctionTurnShowDialog?.call(false);
                getIt.get<CoreFileDataSource>().takeFiles(context: context,callBack: (param){
                  BlocProvider.of<ChatBloc>(widget.buildContext)
                      .onTextChanged
                      .add(param);
                });
              },
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file,size: 40,),
                  SizedBox(width: 10,),
                  Expanded(child: Text("File",style: TextStyle(
                      fontFamily: StyleFontFamily.SarabunMedium,
                      fontSize: StyleFontSize.fontSizeTitleDefault
                  ),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
