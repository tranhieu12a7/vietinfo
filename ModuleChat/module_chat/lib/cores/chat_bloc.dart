import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/cores/chat_state.dart';
import 'package:module_chat/models/model_chat_history.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/service/apis/api_datasource.dart';
import 'package:module_chat/utils/camera/gen_thumbnail_image.dart';
import 'package:module_chat/utils/functions.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:module_chat/utils/pagt_file_locals/path_file_local_datasource.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


class ChatBloc extends Cubit<ChatState> {
  static const String modelParam = "modelParam";
  static const String messagesTypeParam = "messagesTypeParam";
  static const String messagesParam = "messagesParam";
  static const String thumbnailParam = "thumbnailParam";
  static const String messagesIDGroupParam = "messageIDGroupParam";

  ChatBloc._({
    this.onChanged,
    this.getPublishStreamResult,
    this.onTextChanged,
  }) : super(ChatStateInit());

  static List<ModelChatMessages> modelMessagesCurrent;

  // ignore: close_sinks
  final Sink<dynamic> onTextChanged;

  // ignore: close_sinks
  final Sink<ModelChatMessages> onChanged;
  final Stream<List<ModelChatMessages>> getPublishStreamResult;

  // final Stream<ModelChatMessages> getPublishStreamResultOld;
  static ModelChatHistory _dataHistory;

  // ignore: close_sinks
  // static final _onChangePublishSubjectOld = PublishSubject<ModelChatMessages>();

  factory ChatBloc() {
    // ignore: close_sinks
    final onChangePublishSubject = PublishSubject<ModelChatMessages>();
    // ignore: cancel_subscriptions, close_sinks
    final onTextChangePublishSubject = PublishSubject<dynamic>();
    onTextChangePublishSubject.listen((value) async {
      int _messageType = 0;
      String _textMessages, _testMessagesLocal;
      EMessagesType _typeMessage;
      String _messageIDGroup;
      if (value is Map<String, dynamic>) {
        try {
          _typeMessage = value[messagesTypeParam];
          if (value.containsKey(messagesIDGroupParam))
            _messageIDGroup = value[messagesIDGroupParam].toString();
          _messageType = int.parse(CoreFunctions.getMessagesType(_typeMessage));
          _textMessages = value[messagesParam];

          if (_typeMessage == EMessagesType.image ||
              _typeMessage == EMessagesType.video ||
              _typeMessage == EMessagesType.imageGroup) {
            _textMessages = await compressFile(_textMessages);
            if (value.containsKey(thumbnailParam)) {
              var thumb = value[thumbnailParam] as GenThumbnailImage;
              _testMessagesLocal =
                  await compressFile(thumb.thumbnailRequest.thumbnailPath);
            }
          }
        } catch (error) {
          appLogs(error);
        }
      } else {
        _textMessages = value;
      }
      var data = new ModelChatMessages(
        senderId: int.parse(ConfigData.getUserID()),
        message: _textMessages,
        messagesOldLocal: _testMessagesLocal,
        isFireBase: false,
        createDate: DateTime.now(),
        createDateTitle: CoreFunctions.convertDateTime(
            datetime: DateTime.now(),
            typeDateTime: TypeDateTime.HHmmDayMontYear),
        createTime: CoreFunctions.convertDateTime(
            datetime: DateTime.now(), typeDateTime: TypeDateTime.HHmm),
        messageType: _messageType,
        eMessageType: _typeMessage,
        messageIDGroup: _messageIDGroup,
        avatar: ConfigData.getURLAvatar(),
        fullName: ConfigData.getFullName(),
      );

      onChangePublishSubject.sink.add(data);
    });

    final streamResult = onChangePublishSubject
        .switchMap((ModelChatMessages value) => _insertMessages(value));
    // final streamResultOld = _onChangePublishSubjectOld.stream;

    return ChatBloc._(
        onChanged: onChangePublishSubject,
        getPublishStreamResult: streamResult,
        onTextChanged: onTextChangePublishSubject);
  }

  int maxItemMessages = 20;
  int pageNumMessages = 0;

  ///function thumbnail video
  static Future<String> getLinkLocalVideo(
      {ModelChatMessages data, bool isLocal = false}) async {
    try {

      final String dirPathImage = await getIt
          .get<PathFileLocalDataSource>()
          .getPathLocalChat(
              ePathType: EPathType.cache,
              configPathStr: ConfigData.getPathLocalImages());
      String nameFileImage =
          data.message.split("/").last.replaceAll("mp4", "png");
      String filePathImage = dirPathImage + nameFileImage;

      if (File(filePathImage).existsSync()) {
        return filePathImage;
      } else {
        final thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: !isLocal
                ? ConfigData.getUrlWeb() + data.message ?? ""
                : data.message,
            thumbnailPath: filePathImage,
            timeMs: 10,
            quality: 60);
        return thumbnailPath;
      }
    } catch (error) {
      appLogs("getLinkLocalVideo - $error");
    }
  }

  ///compress
  static Future<String> compressFile(String path) async {
    try {
      final String dirPath = await getIt
          .get<PathFileLocalDataSource>()
          .getPathLocalChat(
              ePathType: EPathType.cache,
              configPathStr: ConfigData.getPathLocalImages());

      String nameFile = path.split("/").last;
      String filePath = dirPath + nameFile;

      final result = await FlutterImageCompress.compressAndGetFile(
        path,
        filePath,
        quality: 60,
      );
      return result.path;
    } catch (error) {
      appLogs("compress File - ${error}");
      return path;
    }
  }

  ///function get list messages
  Future<void> takeChatMessages(ModelChatHistory dataHistory) async {
    try {
      //use in case insert your messages new of function "_insertMessages"
      _dataHistory = dataHistory;

      var _senderID = (dataHistory.senderid.toString() == ConfigData.getUserID()
          ? dataHistory.receiverid
          : dataHistory.senderid.toString());

      if (state is ChatStateInit) {
        var data = await getIt.get<ApiDataSource>().takeListMessages(
            groupID: dataHistory.groupId,
            groupCode: dataHistory.groupCode,
            senderID: _senderID,
            pageNum: pageNumMessages,
            pageSize: maxItemMessages);

        if (data != null) {
          List<ModelChatMessages> listDataTemporary = [];

          ModelChatMessages dataTemporary;
          try {
            for (var item in data) {
              //check xem cái image này có nằm trog group image không
              if (item.showType == 3) {
                if (dataTemporary == null) {
                  dataTemporary = item;
                }
                if (dataTemporary.messageIDGroup != item.messageIDGroup) {
                  dataTemporary = item;
                }
                if (dataTemporary.listGroup == null)
                  dataTemporary.listGroup = [];
                dataTemporary.listGroup.add(item);
                int index = listDataTemporary.indexWhere(
                    (element) => element.messageID == dataTemporary.messageID);
                if (index >= 0)
                  listDataTemporary[index] = dataTemporary;
                else {
                  listDataTemporary.add(dataTemporary);
                }
              } else {
                dataTemporary = null;
                //kiểm tra xem nó có phải video không
                //nếu là video thì thumbnail image vào đường dẫn local
                //sau đó lưu vào trong messageOldLocal của ModelMessages
                if (item.messageType == 2) //2 là message video
                {
                  item.messagesOldLocal = await getLinkLocalVideo(data: item);
                }
                listDataTemporary.add(item);
              }
            }
          } catch (error) {
            appLogs(error);
          }
          modelMessagesCurrent = listDataTemporary;
        }

        if (data == null || data.length < maxItemMessages) {
          emit(ChatStateSuccessful().cloneWrite(
              listMessages: modelMessagesCurrent, hasReachedEnd: true));
        } else {
          emit(ChatStateSuccessful().cloneWrite(
              listMessages: modelMessagesCurrent, hasReachedEnd: false));
          pageNumMessages++;
        }
      } else if (state is ChatStateSuccessful &&
          !(state as ChatStateSuccessful).hasReachedEnd) {
        var dataCurrent = (state as ChatStateSuccessful).listMessages;

        var data = await getIt.get<ApiDataSource>().takeListMessages(
            groupID: dataHistory.groupId,
            groupCode: dataHistory.groupCode,
            senderID: _senderID,
            pageNum: pageNumMessages,
            pageSize: maxItemMessages);

        if (data != null) {
          List<ModelChatMessages> listDataTemporary = dataCurrent + data;
          ModelChatMessages dataTemporary;

          if (data.first.showType == 3 && dataCurrent.first.showType == 3) {
            dataTemporary = dataCurrent.first;
          }
          for (var item in data) {
            //check xem cái image này có nằm trog group image không
            // nếu là image group thì tiến hành group image
            if (item.showType == 3) {
              if (dataTemporary == null) {
                dataTemporary = item;
              }
              if (dataTemporary.messageIDGroup != item.messageIDGroup) {
                dataTemporary = item;
              }
              if (dataTemporary.listGroup == null) dataTemporary.listGroup = [];
              dataTemporary.listGroup.add(item);
              int index = listDataTemporary.indexWhere(
                  (element) => element.messageID == dataTemporary.messageID);
              listDataTemporary[index] = dataTemporary;
              if (dataTemporary.messageID != item.messageID)
                listDataTemporary.remove(item);
            } else {
              dataTemporary = null;
              //kiểm tra xem nó có phải video không
              //nếu là video thì thumbnail image vào đường dẫn local
              //sau đó lưu vào trong messageOldLocal của ModelMessages
              if (item.messageType == 2) //2 là message video
              {
                item.messagesOldLocal = await getLinkLocalVideo(data: item);
              }
            }
          }
          modelMessagesCurrent = listDataTemporary;
        }

        if (data == null || data.length < maxItemMessages) {
          emit(ChatStateSuccessful().cloneWrite(
              listMessages: modelMessagesCurrent, hasReachedEnd: true));
        } else {
          emit(ChatStateSuccessful().cloneWrite(
              listMessages: modelMessagesCurrent, hasReachedEnd: false));
          pageNumMessages++;
        }
      }
    } catch (error) {
      appLogs(error);
    }
  }

  static Stream<List<ModelChatMessages>> _insertMessages(
      ModelChatMessages message) async* {
    //taken minutes and day of last item in messages list
    int minutes = DateTime.now()
        .difference(modelMessagesCurrent.first.createDate)
        .inMinutes;
    int dayDifferent =
        DateTime.now().difference(modelMessagesCurrent.first.createDate).inDays;

    //default messages new have showTypeTime=4
    message.showTypeTime = 4;

    // check if this messages new have createDateTime than 1 day,
    // if this messages than 1 day set showTypeTime = 1 to show datetime title of that messages
    // if this messages new not than 1 day, then take messages first default of messages list "_modelMessagesCurrent" because list reverse to check.
    // if that messages have "senderId" equal to messages new then change "showTypeTime" plus 1 or minus 1 depend on case need border and group time
    // if (minutes > 1 && dayDifferent > 1) {//release
    if (minutes > 5) {
      //test
      message.showTypeTime = 1;
    } else {
      if (modelMessagesCurrent.first.senderId == message.senderId) {
        if (modelMessagesCurrent.first.showTypeTime == 1 &&
            (message.messageIDGroup !=
                    modelMessagesCurrent.first.messageIDGroup ||
                message.messageIDGroup == null)) {
          modelMessagesCurrent.first.showTypeTime = 2;
        } else {
          if (modelMessagesCurrent.first.showTypeTime == 4 &&
              (message.messageIDGroup !=
                      modelMessagesCurrent.first.messageIDGroup ||
                  message.messageIDGroup == null)) {
            modelMessagesCurrent.first.showTypeTime = 3;
          }
        }
      }
    }
    //check messageIDGroup in  modelMessagesCurrent
    try {
      if (message.messageIDGroup != null) {
        var dataCheck = modelMessagesCurrent
            .where(
                (element) => element.messageIDGroup == message.messageIDGroup)
            ?.toList();
        if (dataCheck != null && dataCheck.length > 0) {
          int index = modelMessagesCurrent.indexOf(dataCheck.first);
          if (modelMessagesCurrent[index].listGroup == null)
            modelMessagesCurrent[index].listGroup = [];
          modelMessagesCurrent[index].listGroup.add(message);
        } else {
          message.showType = 3;
          message.listGroup = [];
          message.listGroup.insert(0, message);
          modelMessagesCurrent.insert(0, message);
        }
      } else {
        modelMessagesCurrent.insert(0, message);
      }
    } catch (error) {
      appLogs('_insertMessages ${error}');
    }

    //insert to fist default of messages list because that list reverse

    //get value list messages have first item save local
    // appLogs('modelMessagesCurrent ${modelMessagesCurrent.length}');
    // appLogs('modelMessagesCurrent ${modelMessagesCurrent.first.message}');

    yield modelMessagesCurrent;

    //if messages new not from firebase then insert to service later refresh list messages with item messages new
    if (!message.isFireBase) {
      try {
        if (_dataHistory != null) {
          var _senderID =
              (_dataHistory.senderid.toString() == ConfigData.getUserID()
                  ? _dataHistory.receiverid
                  : _dataHistory.senderid.toString());

          var data = await CoreFunctions.insertMessage(message.eMessageType,
              message.message, _dataHistory.groupId.toString(), _senderID,
              messageIDGroup: message.messageIDGroup);
          if (data != null && data.messageID > 0) {
            message.messageID = data.messageID;
            message.createDate = data.createDate;
            message.createTime = data.createTime;
            message.createDateTitle = data.createDateTitle;
            message.showType = data.showType;
            if (message.eMessageType == EMessagesType.file)
              message.message = data.message;

            //only when "showType = 0" and "showTypeTime != 4"  then refresh messages new just
            // avoid case error group time
            if (data.showType == 0 &&
                modelMessagesCurrent.last.showTypeTime != 4) {
              message.showTypeTime = data.showTypeTime;
            }

            if (message.messageIDGroup != null) {
              var dataCheck = modelMessagesCurrent
                  .where((element) =>
                      element.messageIDGroup == message.messageIDGroup)
                  ?.last;
              if (dataCheck != null) {
                int index = modelMessagesCurrent.indexOf(dataCheck);
                int indexItem =
                    modelMessagesCurrent[index].listGroup.indexOf(message);
                modelMessagesCurrent[index].listGroup[indexItem] = message;
              }
            } else {
              var index = modelMessagesCurrent.indexOf(message);
              // print('${index} - ${message.message} - ${message.showTypeTime}');
              modelMessagesCurrent[index] = message;
            }

            yield modelMessagesCurrent;
          }
        }
      } catch (error) {
        appLogs('_insertMessages api ${error}');
      }
    }
  }

  void dispose() {
    onChanged.close();
  }
}
