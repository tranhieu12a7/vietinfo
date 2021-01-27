import 'package:flutter/material.dart';
import 'package:module_chat/config/config_style.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/utils/functions.dart';


class WidgetChatMyItem extends StatefulWidget {
  final ModelChatMessages data;

  const WidgetChatMyItem({Key key, this.data}) : super(key: key);

  @override
  _WidgetChatMyItemState createState() => _WidgetChatMyItemState();
}

class _WidgetChatMyItemState extends State<WidgetChatMyItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(
            child: Visibility(
              visible: (widget.data.showTypeTime == 1 ||
                  widget.data.showTypeTime == 2),
              child: Text('${widget.data.createDateTitle}',
                  style: TextStyle(
                      fontSize: StyleFontSize.itemMessageDateTimeTitle,
                      color: StyleColor.itemChatDateTimeColor)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 98, right: 10.0, bottom: 0.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 CoreFunctions.getWidgetByMessagesType(widget.data,
                    functionType: () =>
                        CoreFunctions.checkYourItemMessageBorder(
                            widget.data.showTypeTime, widget.data.showType),
                    backgroundColor: StyleColor.myItemChat,isMyMessages: true,context: context),
                Visibility(
                  visible: (widget.data.showTypeTime == 4 ||
                      widget.data.showTypeTime == 1),
                  child: Text(
                    '${widget.data.createTime}',
                    style: TextStyle(
                        fontSize: StyleFontSize.itemMessageDateTime,
                        color: StyleColor.myItemChatDateTime),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
