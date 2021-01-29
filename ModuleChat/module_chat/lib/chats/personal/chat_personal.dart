import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/cores/chat_bloc.dart';
import 'package:module_chat/cores/chat_state.dart';
import 'package:module_chat/models/model_chat_history.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/utils/events/event_notify.dart';
import 'package:module_chat/utils/functions.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:module_chat/widgets/widget_appbar.dart';
import 'package:module_chat/widgets/widget_chat_my_item.dart';
import 'package:module_chat/widgets/widget_chat_their_item.dart';
import 'package:module_chat/widgets/widget_dialog_choose.dart';
import 'package:module_chat/widgets/widget_input.dart';

class ChatPersonal extends StatefulWidget {
  static const String modelDataHistory = "modelDataHistory";
  static const String eventMessageInsert = "eventMessageInsert";
  final Map<String, dynamic> paramData;

  const ChatPersonal({Key key,@required this.paramData}) : super(key: key);

  @override
  _ChatPersonalState createState() => _ChatPersonalState();
}

class _ChatPersonalState extends State<ChatPersonal> {
  // List<ModelChatMessages> listChatMessages = [];
  ScrollController _scrollController;
  ModelChatHistory _dataHistory;

  String groupCode, groupName;
  int groupId, senderId;

  bool isShowDialogChooseFile = false;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();

    // event scroll pagination
    scrollToBottom();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    // turn off event scroll pagination
    _scrollController.dispose();
    //remove event insert message
    getIt
        .get<NotifyEvent>()
        .removeAllListener(key: ChatPersonal.eventMessageInsert);
    print('chat personal dispose');

    ConfigData.pageCurrentContext = null;
  }

  // create event scroll pagination
  void scrollToBottom() {
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent == currentScroll) {
        if (_dataHistory != null)
          //call take message by history
          BlocProvider.of<ChatBloc>(this.context)
              .takeChatMessages(_dataHistory);
        // appLogs("dataHistory - groupID - ${_dataHistory.groupId}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //must be added to call notification (snack bar)
    ConfigData.pageCurrentContext = context;

    // print("build ChatPersonal");

    // take data param history
    Map<String, dynamic> paramData =
        widget.paramData ?? new Map<String, dynamic>();
    _dataHistory = paramData[ChatPersonal.modelDataHistory] as ModelChatHistory;
    if (_dataHistory != null) {
      // appLogs("dataHistory - groupID - ${_dataHistory.groupId}");
      // appLogs("initState - groupID - ${_dataHistory?.groupId}  ${_dataHistory?.fullName}");

      // add event insert message, when main call event
      getIt.get<NotifyEvent>().addItemListener(
          key: ChatPersonal.eventMessageInsert,
          function: () {
            try {
              var modelMessage = getIt.get<NotifyEvent>().dataMessages;
              // print('update: ${modelMessage.text}');
              // appLogs("dataHistory addItemListener - groupID - ${_dataHistory.groupId}  ${_dataHistory.fullName}");

              if (_dataHistory.groupId.toString() != modelMessage.groupId)
                return;

              if (modelMessage.userID !=ConfigData.getUserID().toString()) {
                var data = new ModelChatMessages(
                    senderId: int.parse(modelMessage.userID),
                    message: modelMessage.text,
                    createTime: CoreFunctions.convertDateTime(
                        datetime: modelMessage.createDate,
                        typeDateTime: TypeDateTime.HHmm),
                    createDate: modelMessage.createDate,
                    createDateTitle: CoreFunctions.convertDateTime(
                        datetime: modelMessage.createDate,
                        typeDateTime: TypeDateTime.IntDayIntMonthIntYear),
                    messageType: int.parse(modelMessage.imgFlag),
                    messageID: int.parse(modelMessage.messageId),
                    avatar: modelMessage.avatar,
                    messageIDGroup: modelMessage.messageIDGroup,
                    isFireBase: true,
                    showType: int.parse(modelMessage.showType),
                    showTypeTime: int.parse(modelMessage.showTypeTime),
                    fullName: modelMessage.fullName,
                    receiverId: modelMessage.receiver_sender);

                //call event insert message
                BlocProvider.of<ChatBloc>(ConfigData.pageCurrentContext)
                    .onChanged
                    .add(data);
              }
            } catch (error) {
              appLogs(
                  'ChatPersonal -----addItemListener----- ERROR --------- $error.');
            }
          });

      BlocProvider.of<ChatBloc>(context).takeChatMessages(_dataHistory);
    }

    //call take message by history
    else
      return Scaffold(
        appBar: WidgetAppBar(
          buildContext: context,
          title: _dataHistory.fullName,
        ),
        body: SafeArea(
          child: Container(
            child: Align(
              child: Text("Không có dữ liệu"),
              alignment: Alignment.topCenter,
            ),
          ),
        ),
      );

    return Scaffold(
      appBar: WidgetAppBar(
        buildContext: context,
        title: _dataHistory.fullName,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is ChatStateInit) {
                          //loading start, when call api get messages
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        //result call api take messages successful
                        if (state is ChatStateSuccessful) {
                          return StreamBuilder(
                            stream: BlocProvider.of<ChatBloc>(context)
                                .getPublishStreamResult,
                            builder: (context,
                                AsyncSnapshot<List<ModelChatMessages>>
                                    snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data is List<ModelChatMessages> &&
                                    state.listMessages.length <
                                        snapshot.data.length) {
                                  state.listMessages = snapshot.data;
                                }
                              }
                              if (state.listMessages == null)
                                state.listMessages = [];

                              return ListView.builder(
                                  reverse: true,
                                  controller: _scrollController,
                                  itemCount: state.hasReachedEnd
                                      ? state.listMessages.length
                                      : state.listMessages.length + 1,
                                  //add more item,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index >= state.listMessages.length) {
                                      return Container(
                                        alignment: Alignment.center,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1.5,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Đang tải...")
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    if (state.listMessages.length == 0) {
                                      return Container(
                                        child: Center(
                                          child: Text("Không có dữ liệu"),
                                        ),
                                      );
                                    } else if (state
                                            .listMessages[index].senderId ==
                                        int.parse(ConfigData.getUserID())) {
                                      return WidgetChatMyItem(
                                        data: state.listMessages[index],
                                      );
                                    } else {
                                      return WidgetChatTheirItem(
                                        data: state.listMessages[index],
                                      );
                                    }
                                  });
                            },
                          );
                          // },
                          // );
                        }
                        return Container(
                          child: Center(
                            child: Text("Không có dữ liệu"),
                          ),
                        );
                      },
                    ),
                    Visibility(
                      visible: isShowDialogChooseFile,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isShowDialogChooseFile = false;
                              });
                            },
                            child: Opacity(
                              opacity: 0.5,
                              child: Container(
                                color: Colors.grey,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              ),
                            ),
                          ),
                          WidgetDialogChoose(
                            buildContext: context,
                            callFunctionTurnShowDialog: (value) {
                              setState(() {
                                isShowDialogChooseFile = value;
                              });
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              WidgetInputChat(
                buildContext: context,
                isShowDialog: isShowDialogChooseFile,
                callFunctionScrollList: () {
                  // appLogs("dataHistory - groupID - ${_dataHistory.groupId}");

                  _scrollController.jumpTo(
                    0.0,
                  );
                },
                callFunctionShowDialog: (value) {
                  setState(() {
                    isShowDialogChooseFile = value;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
