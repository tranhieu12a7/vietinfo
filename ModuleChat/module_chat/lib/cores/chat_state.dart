import 'package:module_chat/models/model_chat_messages.dart';

class ChatState {
}
class ChatStateInit extends ChatState{
}
class ChatStateSuccessful extends ChatState {
  List<ModelChatMessages> listMessages=[];
  bool hasReachedEnd = false;

  ChatStateSuccessful({this.listMessages,this.hasReachedEnd});
  ChatStateSuccessful cloneWrite({listMessages,data, hasReachedEnd}) {
    return ChatStateSuccessful(
        listMessages: listMessages ?? this.listMessages,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd);
  }
}
