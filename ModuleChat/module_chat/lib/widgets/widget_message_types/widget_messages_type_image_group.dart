
import 'package:flutter/material.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/widgets/widget_message_types/widget_messages_type_image.dart';

class WidgetMessageTypeImageGroup extends StatefulWidget {
  final List<ModelChatMessages> datas;
  final bool isMyMessages;
  final dynamic functionType;

  const WidgetMessageTypeImageGroup(
      {Key key, this.datas, this.isMyMessages, this.functionType})
      : super(key: key);

  @override
  _WidgetMessageTypeImageGroupState createState() =>
      _WidgetMessageTypeImageGroupState();
}

class _WidgetMessageTypeImageGroupState
    extends State<WidgetMessageTypeImageGroup> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      textDirection: TextDirection.ltr,
      crossAxisAlignment: WrapCrossAlignment.end,
      alignment: widget.isMyMessages? WrapAlignment.end: WrapAlignment.start ,
      runSpacing: 4.0,
      spacing: 4.0,
      children: getListImageGroup(widget.datas),
    );
  }
  List<Widget> getListImageGroup(List<ModelChatMessages> datas) {
    List<Widget> listWidget = [];
    if (datas != null)
      for (var item in datas) {
          listWidget.add(Container(
              width: 100,
              height: 100,
              child: WidgetMessageTypeImage(
                data: item,
                datas: datas,
                buildContext: this.context,
              )));
      }
    return listWidget;
  }
}
