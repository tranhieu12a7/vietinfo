import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/chats/personal/chat_personal_main.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/history/bloc/chat_history_state.dart';
import 'package:module_chat/module_chat.dart';
import 'package:module_chat/service/apis/api_datasource.dart';
import 'package:module_chat/utils/logs.dart';

class ChatHistoryBloc extends Cubit<ChatHistoryState> {
  ChatHistoryBloc(ChatHistoryStateInit state) : super(state);

  int maxItemHistory = 20;
  int pageNumHistory = 1;

  Future<void> takeChatHistory() async {
    try {
      if (state is ChatHistoryStateInit) {
        var data = await getIt
            .get<ApiDataSource>()
            .listHistory(pageNum: pageNumHistory);
        if (data == null || data.length < maxItemHistory) {
          emit(ChatHistoryStateSuccessful()
              .cloneWrite(listHistory: data, hasReachedEnd: true));
        } else {
          emit(ChatHistoryStateSuccessful()
              .cloneWrite(listHistory: data, hasReachedEnd: true));
          pageNumHistory++;
        }
      } else if (state is ChatHistoryStateSuccessful &&
          !(state as ChatHistoryStateSuccessful).hasReachedEnd) {
        var dataCurrent = (state as ChatHistoryStateSuccessful).listHistory;

        var data = await getIt
            .get<ApiDataSource>()
            .listHistory(pageNum: pageNumHistory);
        if (data == null || data.length < maxItemHistory) {
          emit(ChatHistoryStateSuccessful().cloneWrite(
              listHistory: dataCurrent + data, hasReachedEnd: true));
        } else {
          emit(ChatHistoryStateSuccessful().cloneWrite(
              listHistory: dataCurrent + data, hasReachedEnd: true));
          pageNumHistory++;
        }
      }
    } catch (error) {
      appLogs(error);
    }
  }

  void TappedBarChange() {}

  Future<Void> logOut(
      {BuildContext context,
      String userName,
      String donViID,
      String token}) async {
    // var dataResult=await getIt.get<LoginDataSource>().RemoveToken(userName,donViID,token);
    // if(dataResult){
    //   AppSettings.setValue(KeyAppSetting.userName, null);
    //   // getIt.get<NavigatorDataSource>().popNavigation(context);
    //   getIt.get<NavigatorDataSource>().pushNavigation(NamePage.loginPage,context: context,countPage: 1);
    // }
  }

  void callNavigatorChatPersonal(
      {BuildContext context, Map<String, dynamic> param}) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChatPersonalMain(
                paramData: param,
              ),
          settings: RouteSettings().copyWith(name: "ChatPersonalPage")),
    );
  }
}
