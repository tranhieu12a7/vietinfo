import 'dart:convert';

import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/models/class_firebase.dart';
import 'package:module_chat/models/model_chat_history.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:vietinfo_dev_core/vietinfo_dev_core.dart';
import 'api_datasource.dart';


class ApiResponse extends ApiDataSource {
  ///Home
  //lấy lịch sử tin nhắn
  @override
  Future<List<ModelChatHistory>> listHistory({int pageNum = 1}) async {
    try {
      final url = ConfigData.getUrl() + '/api/chat/get-history';

      var param = new Map<String, String>();
      param['userID'] = ConfigData.getUserID();
      param['donviID'] = ConfigData.getDonViID();
      param['PageNumber'] = pageNum.toString();
      param['PageSize'] = "20";

      final data = await getIt
          .get<NetworkDataSource>()
          .post(Uri.parse(url), body: param);
      // appLogs(data);
      if (data.status == ENetWorkStatus.Error) {
        return null;
      }
      final dataList = data.dataResult as List;
      final List<ModelChatHistory> list = dataList.map((item) {
        return ModelChatHistory.fromJson(item);
      }).toList();

      return list;
    } catch (error) {
      appLogs(error);
      return null;
    }
  }

  @override
  Future<List<ModelChatMessages>> takeListMessages(
      {String senderID,
        int groupID,
        String groupCode,
        int pageNum,
        int pageSize = 20}) async {
    try {
      final url = ConfigData.getUrl() + '/api/chat/getlist-message-by-userid';

      var param = new Map<String, String>();
      param['userID'] = ConfigData.getUserID();
      param['donviID'] = ConfigData.getDonViID();
      param['toUserID'] = senderID;
      param['groupId'] = groupID.toString();
      param['groupCode'] = groupCode.toString();
      param['PageNumber'] = pageNum.toString();
      param['PageSize'] = pageSize.toString();

      final data = await getIt
          .get<NetworkDataSource>()
          .post(Uri.parse(url), body: param);
      // appLogs(data);
      if (data.status == ENetWorkStatus.Error) {
        return null;
      }
      final dataList = data.dataResult as List;
      final List<ModelChatMessages> list = dataList.map((item) {
        return ModelChatMessages.fromJson(item);
      }).toList();

      return list;
    } catch (error) {
      appLogs(error);
      return null;
    }
  }

  @override
  Future<ModelChatMessages> insertMessage(
      {String IDCrrrent,
        String donviID,
        String senderid,
        String tbody,
        String imgFlag,
        String groupID,
        String messageIDGroup,
        ClassFirebase classFirebase}) async {
    // TODO: implement insertMessage
    try {
      final url = ConfigData.getUrl() + '/api/chat/insert-messages';

      var param = new Map<String, String>();
      param['userID'] = ConfigData.getUserID();
      param['donviID'] = ConfigData.getDonViID();
      param['message'] = tbody;
      param['toUserID'] = senderid;
      param['imgFlag'] = imgFlag;
      param['groupId'] = groupID;
      if (messageIDGroup != null) param['messageIDGroup'] = messageIDGroup;
      param['classFirebase'] = jsonEncode(classFirebase);

      final data = await getIt
          .get<NetworkDataSource>()
          .post(Uri.parse(url), body: param);
      // appLogs(data);
      if (data.status == ENetWorkStatus.Error) {
        return null;
      }
      return ModelChatMessages.fromJson(data.dataResult);
    } catch (error) {
      appLogs(error);
      return null;
    }
  }
}
