import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/chats/personal/chat_personal_state.dart';


class ChatPersonalBloc extends Cubit<ChatPersonalState> {
  ChatPersonalBloc() : super(ChatPersonalState());

  // ChatPersonalBloc._({this.onChanged, this.getPublishStreamResult})
  //     : super(ChatPersonalStateInit());
  //
  // // ignore: close_sinks
  // final Sink<ModelChatMessages> onChanged;
  // final Stream<ModelChatMessages> getPublishStreamResult;
  // static ModelChatHistory _dataHistory;
  //
  // factory ChatPersonalBloc() {
  //   // ignore: close_sinks
  //   final resultPublishSubject = PublishSubject<ModelChatMessages>();
  //
  //   final streamResult = resultPublishSubject.switchMap((ModelChatMessages value) => _insertMessage(value));
  //
  //   return ChatPersonalBloc._(
  //       onChanged: resultPublishSubject, getPublishStreamResult: streamResult);
  // }
  //
  // int maxItemMessage = 20;
  // int pageNumMessage = 0;
  //
  // Future<void> takeChatMessages(ModelChatHistory dataHistory) async {
  //   try {
  //     _dataHistory = dataHistory;
  //
  //     var _senderID = (dataHistory.senderid.toString() == ConfigData.getUserID()
  //         ? dataHistory.receiverid
  //         : dataHistory.senderid.toString());
  //
  //     if (state is ChatPersonalStateInit) {
  //       var data = await getIt.get<ApiDataSource>().takeListMessages(
  //           groupID: dataHistory.groupId,
  //           groupCode: dataHistory.groupCode,
  //           senderID: _senderID,
  //           pageNum: pageNumMessage,
  //           pageSize: maxItemMessage);
  //       if (data == null || data.length < maxItemMessage) {
  //         emit(ChatPersonalStateSuccessful()
  //             .cloneWrite(listMessages: data, hasReachedEnd: true));
  //       } else {
  //         emit(ChatPersonalStateSuccessful()
  //             .cloneWrite(listMessages: data, hasReachedEnd: true));
  //         pageNumMessage++;
  //       }
  //     } else if (state is ChatPersonalStateSuccessful &&
  //         !(state as ChatPersonalStateSuccessful).hasReachedEnd) {
  //       var dataCurrent = (state as ChatPersonalStateSuccessful).listMessages;
  //
  //       var data = await getIt.get<ApiDataSource>().takeListMessages(
  //           groupID: dataHistory.groupId,
  //           groupCode: dataHistory.groupCode,
  //           senderID: _senderID,
  //           pageNum: pageNumMessage,
  //           pageSize: maxItemMessage);
  //       if (data == null || data.length < maxItemMessage) {
  //         emit(ChatPersonalStateSuccessful().cloneWrite(
  //             listMessages: dataCurrent + data, hasReachedEnd: true));
  //       } else {
  //         emit(ChatPersonalStateSuccessful().cloneWrite(
  //             listMessages: dataCurrent + data, hasReachedEnd: true));
  //         pageNumMessage++;
  //       }
  //     }
  //   } catch (error) {
  //     appLogs(error);
  //   }
  // }
  //
  // Future<void> insertMessage(String message) async {
  //   // try {
  //   //   if (_dataHistory != null) {
  //   //     var _senderID =
  //   //         (_dataHistory.senderid.toString() == ConfigData.getUserID()
  //   //             ? _dataHistory.receiverid
  //   //             : _dataHistory.senderid.toString());
  //   //
  //   //     var data = await Functions.insertMessage(
  //   //         "0", message, _dataHistory.groupId.toString(), _senderID);
  //   //     if (data.messageID > 0) {
  //   //       (state as ChatPersonalStateSuccessful)
  //   //           .listMessages
  //   //           .firstWhere((element) => element.messageID == null)
  //   //           ?.messageID = data.messageID;
  //   //       (state as ChatPersonalStateSuccessful).listMessages.firstWhere((
  //   //           element) =>
  //   //       element.messageID==data.messageID).createDate=data.createDate;
  //   //     }
  //   //   }
  //   // } catch (error) {
  //   //   print(error);
  //   // }
  // }
  //
  //
  // static Stream<ModelChatMessages> _insertMessageApi(
  //     ModelChatMessages message) async* {
  //   print(message.senderId);
  //
  //   try {
  //     if (_dataHistory != null) {
  //       var _senderID =
  //       (_dataHistory.senderid.toString() == ConfigData.getUserID()
  //           ? _dataHistory.receiverid
  //           : _dataHistory.senderid.toString());
  //
  //       var data = await Functions.insertMessage(
  //           "0", message.message, _dataHistory.groupId.toString(), _senderID);
  //       if (data.messageID > 0) {
  //         message.messageID=data.messageID;
  //         message.createDate=data.createDate;
  //         yield message;
  //       }
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }
  //
  // static Stream<ModelChatMessages> _insertMessage(
  //     ModelChatMessages message) async* {
  //   print(message.senderId);
  //   yield message;
  //   try {
  //     if (_dataHistory != null) {
  //       var _senderID =
  //       (_dataHistory.senderid.toString() == ConfigData.getUserID()
  //           ? _dataHistory.receiverid
  //           : _dataHistory.senderid.toString());
  //
  //       var data = await Functions.insertMessage(
  //           "0", message.message, _dataHistory.groupId.toString(), _senderID);
  //       if (data.messageID > 0) {
  //         message.messageID=data.messageID;
  //         message.createDate=data.createDate;
  //         yield message;
  //       }
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }
}
