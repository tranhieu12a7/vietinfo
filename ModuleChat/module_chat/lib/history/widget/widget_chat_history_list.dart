import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/chats/personal/chat_personal.dart';
import 'package:module_chat/config/config_style.dart';
import 'package:module_chat/history/bloc/chat_history_bloc.dart';
import 'package:module_chat/history/bloc/chat_history_state.dart';
import 'package:module_chat/models/model_chat_history.dart';

// ignore: must_be_immutable
class WidgetListHistory extends StatefulWidget {
  BuildContext buildContext;
  Function function;

  WidgetListHistory({Key key, this.buildContext, this.function})
      : super(key: key);

  @override
  _WidgetListHistoryState createState() => _WidgetListHistoryState();
}

class _WidgetListHistoryState extends State<WidgetListHistory> {
  final _scrollController = ScrollController();
  final _scrollThreadhold = 5.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<ChatHistoryBloc>(this.context).takeChatHistory();

    //event scroll pagination
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollThreadhold) {
        BlocProvider.of<ChatHistoryBloc>(this.context).takeChatHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
      builder: (context, state) {
        if (state is ChatHistoryStateInit) {
          return Container(
            alignment: Alignment.center,
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              ),
            ),
          );
        }

        if (state is ChatHistoryStateSuccessful) {
          //check empty of list history
          if (state.listHistory == null) {
            return Container(
              alignment: Alignment.center,
              child: Center(child: Text("không có dữ liệu")),
            );
          }
          return Container(
            padding: EdgeInsets.all(5.0),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                //loading start when call event pagination
                if (index >= state.listHistory.length) {
                  return Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                  );
                }
                //result data list history
                else {
                  return Column(
                    children: [
                      itemHistory(state.listHistory[index]),
                      SizedBox(
                        child: Container(
                          color: Colors.grey[300],
                        ),
                        height: 1,
                      )
                    ],
                  );
                }
              },
              itemCount: state.hasReachedEnd
                  ? state.listHistory.length
                  : state.listHistory.length + 1, //add more item
              controller: _scrollController,
            ),
          );
        } else {
          return Center(
            child: Text("Không có dữ liệu"),
          );
        }
      },
    );
  }

  Widget itemHistory(ModelChatHistory data) {
    return GestureDetector(
      onTap: () {
        // add model history
        Map<String, dynamic> param = new Map<String, dynamic>();
        param[ChatPersonal.modelDataHistory] = data;

        //call navigation page chat personal
        BlocProvider.of<ChatHistoryBloc>(widget.buildContext)
            .callNavigatorChatPersonal(context: context, param: param);
        // ConfigSetting.getNavigator().pushNavigation(NamePage.chat_personal,
        //     params: {"paramData": param});
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.grey[200],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data.fullName}',
                    style: TextStyle(
                        fontSize: StyleFontSize.fontSizeTitleDefault,
                        fontFamily: StyleFontFamily.SarabunMedium),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${data.message}',
                    style: TextStyle(
                        fontFamily: StyleFontFamily.SarabunRegular,
                        color: Color(0xff838c9b)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
