import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/config/config_style.dart';
import 'package:module_chat/history/bloc/chat_history_bloc.dart';
import 'package:module_chat/history/widget/chat_history_appbar.dart';
import 'package:module_chat/history/widget/widget_chat_history_list.dart';


class ChatHistory extends StatefulWidget {
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  String text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    //
    // //must be added to call notification (snack bar)
    // ConfigData.pageCurrentContext=null;

    return Scaffold(
      appBar: ChatHistoryAppBar(
        height: 120,
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                child: Icon(Icons.chat),
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Chat demo",
                                  style: TextStyle(
                                      fontSize:
                                          StyleFontSize.fontSizeTitleDefault +
                                              5.0,
                                      fontFamily: StyleFontFamily.SarabunBold),
                                ),
                                Text(
                                  "Chat demo",
                                  style: TextStyle(
                                      fontSize: StyleFontSize.fontSizeDefault,
                                      fontFamily: StyleFontFamily.SarabunMedium,
                                      color: Color(0xff9eabbe)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              child: Icon(
                                Icons.search,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              backgroundColor: Color(0xff2f75b5),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<ChatHistoryBloc>(context).logOut(
                                  context: context,
                                  userName: ConfigData.getUserName(),
                                  donViID: ConfigData.getDonViID(),
                                  token: ConfigData.getToken());
                            },
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.logout,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                                backgroundColor: Color(0xff3ec193),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  decoration: BoxDecoration(color: const Color(0xffeaeff5)))
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TappedBarKindMessages(),
              Expanded(child: WidgetListHistory(buildContext: context,))
            ],
          ),
        ),
      ),
    );
  }
}

class TappedBarKindMessages extends StatefulWidget {
  @override
  _TappedBarKindMessagesState createState() => _TappedBarKindMessagesState();
}

class _TappedBarKindMessagesState extends State<TappedBarKindMessages> {
  List<String> listTitleTappedBar = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listTitleTappedBar.add("Cá nhân");
    listTitleTappedBar.add("Nhóm");
    listTitleTappedBar.add("Công việc");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              getTappedBar(context: context, listTitle: listTitleTappedBar),
        ),
      ),
    );
  }

  List<Widget> getTappedBar({BuildContext context, List<String> listTitle}) {
    List<Widget> listWidget = [];
    if (listTitle == null) {
      listTitle.add("Tất cả");
    }
    for (var item in listTitle) {
      listWidget.add(Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width / 3,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x12000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  spreadRadius: 1)
            ],
            color: const Color(0xffffffff)),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Center(
          child: Text(
            item,
            style: TextStyle(
                fontFamily: StyleFontFamily.SarabunBold,
                fontSize: StyleFontSize.fontSizeTitleDefault - 2.0),
          ),
        ),
      ));
    }
    return listWidget;
  }
}
