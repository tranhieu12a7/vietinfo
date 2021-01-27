import 'dart:io';

import 'package:flutter/material.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/utils/open_files/image/image_view.dart';


class WidgetMessageTypeImage extends StatefulWidget {
  final BuildContext buildContext;
  ModelChatMessages data;
  List<ModelChatMessages> datas;
  final Function functionType;

  WidgetMessageTypeImage(
      {Key key, this.data, this.datas, this.buildContext, this.functionType})
      : super(key: key);

  @override
  _WidgetMessageTypeImageState createState() => _WidgetMessageTypeImageState();
}

class _WidgetMessageTypeImageState extends State<WidgetMessageTypeImage> {
  void showImage(bool isLocal) async {
    if (widget.datas != null){
      await Navigator.push<dynamic>(
          this.context,
          MaterialPageRoute(
              builder: (context) => ImageViewScreen(
                data: widget.data,
                datas: widget.datas,
                isLocal: isLocal,
              )));
    }else{
      await Navigator.push<dynamic>(
          this.context,
          MaterialPageRoute(
              builder: (context) => ImageViewScreen(
                data: widget.data,
                isLocal: isLocal,
              )));
    }

  }

  @override
  Widget build(BuildContext context) {
    try {
      if (widget.data.eMessageType != null) {
        return GestureDetector(
          onTap: () => showImage(true),
          child: Image.file(
            File(widget.data.message),
            fit: BoxFit.cover,
          ),
        );
      } else {
        return GestureDetector(
          onTap: () => showImage(false),
          child: Image.network(
              !widget.data.message.contains(ConfigData.getUrlWeb())
                  ? ConfigData.getUrlWeb() + widget.data.message
                  : widget.data.message,
              fit: BoxFit.cover),
        );
      }
    } catch (error) {
      print(error);
    }
  }
}
