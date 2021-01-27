import 'dart:convert';

class ClassFirebase {
  List<String> registration_ids = [];
  String to = "";
  objNotifis notification;
  objdata data;

  ClassFirebase({this.registration_ids, this.to, this.notification, this.data});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['registration_ids'] = this.registration_ids;
    data['to'] = this.to;
    data['notification'] = jsonDecode(jsonEncode(this.notification));
    data['data'] = jsonDecode(jsonEncode(this.data));
    return data;
  }
}

class objNotifis {
  String title = "";
  String body = "";
  String sound = "";
  String click_action = "";

  objNotifis({this.title, this.body, this.sound, this.click_action});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['sound'] = this.sound;
    data['click_action'] = this.click_action;
    return data;
  }
}

class objdata {
  String text = "";
  String userID = "";
  String imgFlag = "";
  String avatar = "";
  String fullName = "";
  String groupId = "";
  String groupCode = "";
  String groupName = "";
  String flagGroup = "";
  String receiver_sender = "";
  String messageId = "";
  String logout = "";
  String key = "";
  String id = "";
  String isReplay = "";
  String showType = "";
  String showTypeTime = "";
  String messageIDGroup;
  DateTime createDate ;

  objdata(
      {this.text,
        this.userID,
        this.imgFlag,
        this.avatar,
        this.fullName,
        this.groupId,
        this.groupCode,
        this.groupName,
        this.createDate,
        this.flagGroup,
        this.receiver_sender,
        this.messageId,
        this.logout,
        this.key,
        this.id,
        this.isReplay,
        this.showType,
        this.showTypeTime,
        this.messageIDGroup});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['userID'] = this.userID;
    data['imgFlag'] = this.imgFlag;
    data['avatar'] = this.avatar;
    data['fullName'] = this.fullName;
    data['groupId'] = this.groupId;
    data['groupCode'] = this.groupCode;
    data['groupName'] = this.groupName;
    data['flagGroup'] = this.flagGroup;
    data['receiver_sender'] = this.receiver_sender;
    data['messageId'] = this.messageId;
    data['logout'] = this.logout;
    data['key'] = this.key;
    data['id'] = this.id;
    data['isReplay'] = this.isReplay;
    data['messageIDGroup'] = this.messageIDGroup;
    return data;
  }
}
