
import 'package:module_chat/models/model_chat_history.dart';

class ChatHistoryState {
  ChatHistoryState initData() {}
}
class ChatHistoryStateInit extends ChatHistoryState {
  @override
  ChatHistoryState initData() {
    super.initData();
    // TODO: implement initData
    return ChatHistoryStateInit();
  }
}

class ChatHistoryStateSuccessful extends ChatHistoryState {
  List<ModelChatHistory> listHistory = [];
  bool hasReachedEnd = false;

  ChatHistoryStateSuccessful({this.listHistory, this.hasReachedEnd});

  ChatHistoryStateSuccessful cloneWrite({listHistory, hasReachedEnd}) {
    return ChatHistoryStateSuccessful(
        listHistory: listHistory ?? this.listHistory,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd);
  }
}
