import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/models/class_firebase.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:http/http.dart' as http;
import 'package:module_chat/service/apis/api_datasource.dart';
import 'package:module_chat/service/files/file_datasource.dart';
import 'package:module_chat/widgets/widget_message_types/widget_messages_type_file.dart';
import 'package:module_chat/widgets/widget_message_types/widget_messages_type_image.dart';
import 'package:module_chat/widgets/widget_message_types/widget_messages_type_image_group.dart';
import 'package:module_chat/widgets/widget_message_types/widget_messages_type_text.dart';
import 'package:module_chat/widgets/widget_message_types/widget_messages_type_video.dart';

import 'logs.dart';

class CoreFunctions {
  // ignore: missing_return
  static Future<ModelChatMessages> insertMessagesFile(
      EMessagesType messagesType,
      String tbody,
      String groupID,
      String senderID,
      String messageIDGroup) async {
    try {
      String urlFile;
      var filename = tbody.split('/').last;
      var typeFile = tbody.split('.').last;

      http.ByteStream stream;
      stream = await getIt.get<FileDataSource>().UploadFile(tbody, filename);

      await stream.transform(utf8.decoder).forEach((element) {
        if (element != null) {
          urlFile = jsonDecode(element).toString();
          appLogs('urlFile: : : : ${urlFile}');
        }
      });
      appLogs('urlFile: : : : ${urlFile}');
      return await insertMessagesText(messagesType, urlFile, groupID, senderID,
          messageIDGroup: messageIDGroup);
    } catch (error) {
      appLogs(error);
      return null;
    }
  }

  static Future<ModelChatMessages> insertMessagesText(
      EMessagesType messagesType, String tbody, String groupID, String senderID,
      {messageIDGroup}) async {
    try {
      String imgFlag = getMessagesType(messagesType);

      String text = _getTitleByImgFlag(imgFlag);
      text = (text == "") ? tbody : text;
      ClassFirebase item_firebase = new ClassFirebase();
      item_firebase.notification = new objNotifis();
      item_firebase.data = new objdata();
      item_firebase.notification.body = text;
      item_firebase.notification.title = ConfigData.getFullName();
      item_firebase.notification.sound = "default";
      item_firebase.data.text =
      (imgFlag != "0") ? ConfigData.getUrlWeb() + tbody : tbody;
      item_firebase.data.imgFlag = imgFlag;
      item_firebase.data.userID = ConfigData.getUserID();
      item_firebase.data.fullName = ConfigData.getFullName();
      item_firebase.data.avatar = ConfigData.getURLAvatar();
      item_firebase.data.groupId = groupID;
      item_firebase.data.groupCode = "6";
      item_firebase.data.groupName = "";
      item_firebase.data.logout = "No";
      item_firebase.data.flagGroup = "0";
      item_firebase.data.receiver_sender = "";
      item_firebase.data.messageIDGroup = messageIDGroup?.toString();
      if (groupID != null && groupID != "0" && groupID.isNotEmpty) {
        var dataInsertMessage = await getIt.get<ApiDataSource>().insertMessage(
            groupID: groupID,
            donviID: ConfigData.getDonViID(),
            imgFlag: imgFlag,
            IDCrrrent: ConfigData.getUserID(),
            senderid: senderID,
            tbody: tbody,
            messageIDGroup: messageIDGroup?.toString(),
            classFirebase: item_firebase);

        // print('${dataInsertMessage.messageID} - ${dataInsertMessage.message}');
        return dataInsertMessage;
      }
      return null;
    } catch (error) {
      appLogs(error);
      return null;
    }
  }

  //insert message to service
  static Future<ModelChatMessages> insertMessage(
      EMessagesType messagesType, String tbody, String groupID, String senderID,
      {messageIDGroup}) async {
    switch (messagesType) {
      case EMessagesType.image:
      case EMessagesType.file:
      case EMessagesType.video:
        return await insertMessagesFile(
            messagesType, tbody, groupID, senderID, messageIDGroup);
      default:
        return await insertMessagesText(messagesType, tbody, groupID, senderID);
        return null;
    }
  }

  static String getMessagesType(EMessagesType messagesType) {
    if (messagesType == EMessagesType.image)
      return "1";
    else if (messagesType == EMessagesType.video)
      return "2";
    else if (messagesType == EMessagesType.file)
      return "4";
    else
      return "0";
  }

  //get text default by typeFile
  static String _getTitleByImgFlag(String typeFile) {
    switch (typeFile) {
      case "1":
        return "Đã gửi 1 ảnh";
      case "2":
        return "Đã gửi 1 video";
      case "4":
        return "Đã gửi 1 tập tin";
      default:
        return "";
    }
  }

  //check border their item message
  static BorderRadius checkTheirItemMessageBorder(
      int showTypeTime, int showType) {
    switch (showTypeTime) {
      case 1:
      case 2:
      case 3:
        return BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(15.0),
        );
      case 4:
        return BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        );
    }
  }

  //check border your item message
  static BorderRadius checkYourItemMessageBorder(
      int showTypeTime, int showType) {
    switch (showTypeTime) {
      case 1:
      case 2:
        return BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(0.0),
        );
      case 3:
        if (showType == 0)
          return BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(0.0),
          );
        return BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(0.0),
        );
      case 4:
        return BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        );
    }
  }

  static Widget getWidgetByMessagesType(ModelChatMessages modelData,
      {Function functionType,
        Color backgroundColor,
        BuildContext context,
        bool isMyMessages = false}) {


    if (modelData.eMessageType == null) {
      switch (modelData.messageType) {
        case 1:
          if (modelData.showType == 3) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: WidgetMessageTypeImageGroup(
                  datas: modelData.listGroup,
                  isMyMessages: isMyMessages,
                ),
              ),
            );
          }
          return Padding(
            padding: isMyMessages
                ? EdgeInsets.only(left: 100)
                : EdgeInsets.only(right: 100.0),
            child: ClipRRect(
              // borderRadius: widget.functionType(widget.data.showTypeTime,widget.data.showType),
              borderRadius: BorderRadius.circular(15.0),
              child: WidgetMessageTypeImage(
                data: modelData,
                buildContext: context,
              ),
            ),
          );
        case 2:
          return Padding(
            padding: isMyMessages
                ? EdgeInsets.only(left: MediaQuery.of(context).size.width/3)
                : EdgeInsets.only(right:MediaQuery.of(context).size.width/3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: WidgetMessageTypeVideo(
                  data: modelData,
                  urlWeb: ConfigData.getUrlWeb(),
                  cxt: context,
                ),
              ),
            ),
          );
        case 4:
          return Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Color(0xfff3f5f9),
                  borderRadius: BorderRadius.circular(15.0)),
              child: WidgetMessageTypeFile(
                data: modelData,
                buildContext: context,
              ));
        default:
          return Container(
            decoration: BoxDecoration(
                color: backgroundColor, borderRadius: functionType.call()),
            child: WidgetMessageTypeText(
              data: modelData,
            ),
          );
      }
    } else {
      switch (modelData.eMessageType) {
        case EMessagesType.image:
          if (modelData.showType == 3) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: WidgetMessageTypeImageGroup(
                  datas: modelData.listGroup,
                  isMyMessages: isMyMessages,
                ),
              ),
            );
          }
          return Padding(
            padding:
            isMyMessages ? EdgeInsets.only(left: 100) : EdgeInsets.all(0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: WidgetMessageTypeImage(
                data: modelData,
                buildContext: context,
              ),
            ),
          );
        case EMessagesType.video:
          return Padding(
            padding:
            isMyMessages ? EdgeInsets.only(left: MediaQuery.of(context).size.width/3) : EdgeInsets.all(0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: WidgetMessageTypeVideo(
                  data: modelData,
                  cxt: context,
                ),
              ),
            ),
          );
        case EMessagesType.file:
          return Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Color(0xfff3f5f9),
                  borderRadius: BorderRadius.circular(15.0)),
              child: WidgetMessageTypeFile(
                data: modelData,
                buildContext: context,
              ));

        default:
          return Container(
            decoration: BoxDecoration(
                color: backgroundColor, borderRadius: functionType.call()),
            child: WidgetMessageTypeText(
              data: modelData,
            ),
          );
      }
    }
  }

  //convert datetime all your messages and their messages
  static String convertDateTime(
      {DateTime datetime, TypeDateTime typeDateTime}) {
    String dataStr = "";
    switch (typeDateTime) {
      case TypeDateTime.IntDayStringMonthIntYear:
        dataStr =
        '${datetime.day} ${getMonthString(datetime.month)} ${datetime.year}';
        return dataStr;
      case TypeDateTime.IntDayIntMonthIntYear:
        dataStr = '${datetime.day} Tháng ${datetime.month} ${datetime.year}';
        return dataStr;
      case TypeDateTime.HHmm:
        return DateFormat("HH:mm").format(datetime);
      case TypeDateTime.DayMonthYear:
        return DateFormat("dd/MM/yyyy").format(datetime);
      case TypeDateTime.HHmmDayMontYear:
        return DateFormat("HH:mm dd/MM/yyyy").format(datetime);
      case TypeDateTime.HHmmssddMMyyyy:
        return DateFormat("HHmmssddMMyyyy").format(datetime);
    }
    return DateFormat("hh:mm dd/MM/yyyy").format(datetime);
  }

  static String getMonthString(int numberMonth) {
    switch (numberMonth) {
      case 1:
        return "Tháng Một";
      case 2:
        return "Tháng Hai";
      case 3:
        return "Tháng Ba";
      case 4:
        return "Tháng Tư";
      case 5:
        return "Tháng Năm";
      case 6:
        return "Tháng Sáu";
      case 7:
        return "Tháng Bảy";
      case 8:
        return "Tháng Tám";
      case 9:
        return "Tháng Chín";
      case 10:
        return "Tháng Mười";
      case 11:
        return "Tháng Mười Một";
      case 12:
        return "Tháng Mười Hai";
    }
  }
}

enum TypeDateTime {
  IntDayStringMonthIntYear,
  IntDayIntMonthIntYear,
  DayMonthYear,
  HHmmDayMontYear,
  HHmm,
  HHmmssddMMyyyy
}

enum EMessagesType {
  image,
  imageGroup,
  video,
  file,
  text,
}
