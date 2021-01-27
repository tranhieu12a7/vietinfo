class ModelChatHistory {
  int groupId;
  String groupCode;
  String groupName;
  String message;
  String createDate;
  int messageid;
  int createdUserid;
  int flagIDGroup;
  String listUserName;
  int imgFlag;
  int senderid;
  String receiverid;
  int unReadCount;
  String fullName;
  String avatar;
  int notExist;

  ModelChatHistory(
      {this.groupId,
        this.groupCode,
        this.groupName,
        this.message,
        this.createDate,
        this.messageid,
        this.createdUserid,
        this.flagIDGroup,
        this.listUserName,
        this.imgFlag,
        this.senderid,
        this.receiverid,
        this.unReadCount,
        this.fullName,
        this.avatar,
        this.notExist});

  ModelChatHistory.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupCode = json['groupCode'];
    groupName = json['groupName'];
    message = json['message'];
    createDate = json['createDate'];
    messageid = json['messageid'];
    createdUserid = json['createdUserid'];
    flagIDGroup = json['flagIDGroup'];
    listUserName = json['listUserName'];
    imgFlag = json['imgFlag'];
    senderid = json['senderid'];
    receiverid = json['receiverid'];
    unReadCount = json['unReadCount'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    notExist = json['notExist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['groupCode'] = this.groupCode;
    data['groupName'] = this.groupName;
    data['message'] = this.message;
    data['createDate'] = this.createDate;
    data['messageid'] = this.messageid;
    data['createdUserid'] = this.createdUserid;
    data['flagIDGroup'] = this.flagIDGroup;
    data['listUserName'] = this.listUserName;
    data['imgFlag'] = this.imgFlag;
    data['senderid'] = this.senderid;
    data['receiverid'] = this.receiverid;
    data['unReadCount'] = this.unReadCount;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['notExist'] = this.notExist;
    return data;
  }
}