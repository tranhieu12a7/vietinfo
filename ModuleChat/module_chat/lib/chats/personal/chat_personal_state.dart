
import 'package:module_chat/models/model_chat_messages.dart';

class ChatPersonalState {
}
class ChatPersonalStateInit extends ChatPersonalState{
}
class ChatPersonalStateSuccessful extends ChatPersonalState {
  List<ModelChatMessages> listMessages=[];
  bool hasReachedEnd = false;

  ChatPersonalStateSuccessful({this.listMessages,this.hasReachedEnd});
  ChatPersonalStateSuccessful cloneWrite({listMessages,data, hasReachedEnd}) {
    return ChatPersonalStateSuccessful(
        listMessages: listMessages ?? this.listMessages,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd);
  }
}
