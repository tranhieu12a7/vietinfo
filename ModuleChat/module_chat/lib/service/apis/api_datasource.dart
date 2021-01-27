import 'package:module_chat/models/class_firebase.dart';
import 'package:module_chat/models/model_chat_history.dart';
import 'package:module_chat/models/model_chat_messages.dart';

abstract class ApiDataSource {
  ///Home
  //lấy lịch sử tin nhắn,( note: param dc truyền tực tiếp trong response)
  Future<List<ModelChatHistory>> listHistory({int pageNum = 1});

  //lấy danh sách tin nhắn theo các userID có trong cuộc trò chuyện
  Future<List<ModelChatMessages>> takeListMessages(
      {String senderID,
        int groupID,
        String groupCode,
        int pageNum,
        int pageSize = 20});

  Future<ModelChatMessages> insertMessage(
      {String IDCrrrent,
        String donviID,
        String senderid,
        String tbody,
        String imgFlag,
        String groupID,
        String messageIDGroup,
        ClassFirebase classFirebase});



}