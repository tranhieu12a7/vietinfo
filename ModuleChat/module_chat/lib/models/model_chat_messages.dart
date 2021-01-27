import 'package:module_chat/utils/functions.dart';

class ModelChatMessages {
  int messageID;
  int messageType;
  String message;
  String fullName;
  String avatar;
  String createTime;
  DateTime createDate;
  String createDateTitle;
  String receiverId;
  int senderId;
  String viewer;
  int viewerNumber;
  bool isDelete;
  bool isFireBase;
  int showType;
  int showTypeTime;
  String messageIDGroup;
  EMessagesType eMessageType;
  List<ModelChatMessages> listGroup;
  bool isShowFileDownload = false;
  bool isShowLoadingFile = false;
  double showFileDownloadLoading = 0.0;
  String messagesOldLocal;
  bool isDownload;


  ModelChatMessages(
      {this.messageID,
        this.messageType,
        this.message,
        this.fullName,
        this.avatar,
        this.createDate,
        this.createDateTitle,
        this.createTime,
        this.receiverId,
        this.senderId,
        this.viewer,
        this.viewerNumber,
        this.isDelete,
        this.isFireBase = true,
        this.isShowFileDownload = false,
        this.isShowLoadingFile = false,
        this.showFileDownloadLoading = 0.0,
        this.showType,
        this.showTypeTime,
        this.eMessageType,
        this.messageIDGroup,
        this.listGroup,
        this.messagesOldLocal,
        this.isDownload
      });

  ModelChatMessages.fromJson(Map<String, dynamic> json) {
    messageID = json['messageID'];
    messageType = json['messageType'];
    message = json['message'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    if (json['createDate'] != null) {
      DateTime _dateTime = DateTime.parse(json['createDate']);
      createTime = CoreFunctions.convertDateTime(
          datetime: _dateTime, typeDateTime: TypeDateTime.HHmm);
      createDate = _dateTime;
      createDateTitle = CoreFunctions.convertDateTime(
          datetime: _dateTime, typeDateTime: TypeDateTime.HHmmDayMontYear);
    }
    if (json['messageIDGroup'] != null)
      messageIDGroup = json['messageIDGroup'].toString();
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    viewer = json['viewer'] ?? "";
    viewerNumber = json['viewerNumber'];
    isDelete = json['isDelete'];
    showTypeTime = json['showTypeTime'] ?? 0;
    showType = json['showType'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageID'] = this.messageID;
    data['messageType'] = this.messageType;
    data['message'] = this.message;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['createDate'] = this.createDate;
    data['senderId'] = this.senderId;
    data['viewer'] = this.viewer;
    data['viewerNumber'] = this.viewerNumber;
    data['isDelete'] = this.isDelete;
    return data;
  }
}
