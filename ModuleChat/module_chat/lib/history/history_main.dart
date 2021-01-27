


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/history/bloc/chat_history_bloc.dart';
import 'package:module_chat/history/bloc/chat_history_state.dart';
import 'package:module_chat/history/page/chat_history.dart';




class HistoryMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<ChatHistoryBloc>(
      create: (_) =>
          ChatHistoryBloc(ChatHistoryStateInit().initData()),
      child: ChatHistory(),
    );
  }
}
