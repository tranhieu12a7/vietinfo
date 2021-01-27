
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/utils/open_files/file/file_bloc.dart';
import 'package:module_chat/utils/open_files/file/file_event.dart';
import 'package:module_chat/utils/open_files/file/file_page.dart';

class WidgetMessageTypeFile extends StatefulWidget {
  final BuildContext buildContext;
  ModelChatMessages data;
  final Function functionType;

  WidgetMessageTypeFile(
      {Key key, this.buildContext, this.data, this.functionType})
      : super(key: key);

  @override
  _WidgetMessageTypeFileState createState() => _WidgetMessageTypeFileState();
}

class _WidgetMessageTypeFileState extends State<WidgetMessageTypeFile> {
  @override
  Widget build(BuildContext context) {
    String nameFile = widget.data.message.split("/").last;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.insert_drive_file_outlined),
              Expanded(
                  child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${nameFile}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              height: 1,
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              String path, url;
              if (widget.data.eMessageType != null) {
                path = widget.data.message;
              } else {
                url = widget.data.message;
              }
              BlocProvider.of<FileBloc>(context)
                  .add(FileEventStartDownload(data: widget.data));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tải xuống",
                ),
                FileDownloadPage(buildContext: context,data: widget.data,)
                // ,Icon(Icons.file_download)
              ],
            ),
          )
        ],
      ),
    );
  }
}
