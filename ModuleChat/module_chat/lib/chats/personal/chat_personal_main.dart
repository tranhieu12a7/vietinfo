

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/chats/personal/chat_personal.dart';
import 'package:module_chat/chats/personal/chat_personal_bloc.dart';
import 'package:module_chat/cores/chat_bloc.dart';
import 'package:module_chat/utils/open_files/file/file_bloc.dart';

class ChatPersonalMain extends StatelessWidget {
  final Map<String, dynamic> paramData;

  const ChatPersonalMain({Key key, this.paramData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatPersonalBloc>(
          create: (context) => ChatPersonalBloc(),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(),
        ),
        BlocProvider<FileBloc>(
          create: (context) => FileBloc(),
        ),
      ],
      child: ChatPersonal(paramData: paramData,),
    );
  }
}
