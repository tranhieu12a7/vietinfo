
import 'package:flutter/material.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/config/config_style.dart';
import 'package:module_chat/models/model_chat_messages.dart';

class WidgetMessageTypeText extends StatefulWidget {
  final ModelChatMessages data;

  const WidgetMessageTypeText({Key key, this.data}) : super(key: key);

  @override
  _WidgetMessageTypeTextState createState() => _WidgetMessageTypeTextState();
}

class _WidgetMessageTypeTextState extends State<WidgetMessageTypeText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
      child: Text(
        '${widget.data.message}',
        style: TextStyle(
            fontFamily: StyleFontFamily.SarabunRegular,
            fontSize: StyleFontSize.itemMessageBodyMessage,
            color: widget.data.senderId == int.parse(ConfigData.getUserID())
                ? StyleColor.myItemChatBodyMessage
                : StyleColor.theirItemChatBodyMessage),
      ),
    );
  }
}
