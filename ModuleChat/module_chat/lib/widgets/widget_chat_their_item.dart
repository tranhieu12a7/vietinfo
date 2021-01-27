import 'package:flutter/material.dart';
import 'package:module_chat/config/config_style.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/utils/functions.dart';


class WidgetChatTheirItem extends StatefulWidget {
  final ModelChatMessages data;

  const WidgetChatTheirItem({Key key, this.data}) : super(key: key);

  @override
  _WidgetChatYourItemState createState() => _WidgetChatYourItemState();
}

class _WidgetChatYourItemState extends State<WidgetChatTheirItem> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Visibility(
              visible: (widget.data.showTypeTime == 1 ||
                  widget.data.showTypeTime == 2),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text('${widget.data.createDateTitle}',
                    style: TextStyle(
                        fontSize: StyleFontSize.itemMessageDateTimeTitle,
                        color: StyleColor.itemChatDateTimeColor)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 5.0, right: 60.0, bottom: 0.0, top: 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Visibility(
                      visible: (widget.data.showType == 0),
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: StyleColor.theirItemChat,
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: (widget.data.showType == 0),
                        child: Text(
                          '${widget.data.fullName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: StyleFontFamily.SarabunRegular,
                              color: Color(0xffa2abb9),
                              fontSize: StyleFontSize.itemMessageTitleFullName),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      CoreFunctions.getWidgetByMessagesType(widget.data,
                          functionType: () =>
                              CoreFunctions.checkTheirItemMessageBorder(
                                  widget.data.showTypeTime,
                                  widget.data.showType),
                          backgroundColor: StyleColor.theirItemChat,
                          context: context),

                      ///date time bottom of one item message
                      Visibility(
                        visible: (widget.data.showTypeTime == 4 ||
                            widget.data.showTypeTime == 1),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            '${widget.data.createTime}',
                            style: TextStyle(
                                fontSize: StyleFontSize.itemMessageDateTime,
                                color: StyleColor.theirItemChatDateTimeBottom),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
