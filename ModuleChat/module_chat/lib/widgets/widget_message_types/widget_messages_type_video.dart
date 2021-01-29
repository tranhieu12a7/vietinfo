import 'dart:io';

import 'package:flutter/material.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:module_chat/utils/open_files/video/video_player.dart';


class WidgetMessageTypeVideo extends StatefulWidget {
  ModelChatMessages data;
  String urlWeb;
  BuildContext cxt;
  final Function functionType;

  WidgetMessageTypeVideo(
      {Key key, this.functionType, this.urlWeb, this.data, this.cxt})
      : super(key: key);

  @override
  _WidgetMessageTypeVideoState createState() => _WidgetMessageTypeVideoState();
}

class _WidgetMessageTypeVideoState extends State<WidgetMessageTypeVideo> {
  String filePath;

  Image imageLocal;

  String fileStr;

  // Future<GenThumbnailImage> getThumbnailVideo() async {
  //   GenThumbnailImage thumbnailImage;
  //
  //   final String dirPath = await getIt
  //       .get<PathFileLocalDataSource>()
  //       .getPathLocalChat(
  //           ePathType: EPathType.cache,
  //           configPathStr: ConfigData.getPathLocalImages());
  //
  //   String nameFile =
  //       widget.data.message.split("/").last.replaceAll("mp4", "png");
  //   filePath = dirPath + nameFile;
  //
  //   if (File(filePath).existsSync()) {
  //     imageLocal = Image.file(
  //       File(filePath),
  //       fit: BoxFit.fill,
  //     );
  //     appLogs("imageLocal - ${filePath} ");
  //
  //     return null;
  //   } else {
  //     try {
  //       appLogs("GenThumbnailImage");
  //       thumbnailImage = new GenThumbnailImage(
  //         thumbnailRequest: ThumbnailRequest(
  //             video: (widget.data.message.contains(widget.urlWeb ?? ""))
  //                 ? widget.data.message
  //                 : widget.urlWeb + widget.data.message,
  //             thumbnailPath: filePath,
  //             //imageFormat: ImageFormat.PNG,
  //             timeMs: 20,
  //             quality: 100),
  //         heightImage: MediaQuery.of(widget.cxt).size.height,
  //         widthImage: MediaQuery.of(widget.cxt).size.width,
  //         onSubmitted: (Uint8List value) {
  //           // setState(() {
  //           //   valueByte = value;
  //           // });
  //         },
  //       );
  //     } catch (error) {
  //       appLogs("widget.data.message - ${error}");
  //     }
  //     return thumbnailImage;
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // appLogs("messageID ${widget.data.messageID}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.data.messagesOldLocal != null
            ? Image.file(
              File("${widget.data.messagesOldLocal}"),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            )
            : Container(
                color: Colors.grey,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
              ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {



                    await Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                                  data: widget.data,
                                  isLocal: widget.data.eMessageType != null
                                      ? true
                                      : false,
                                )));
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(00, 00, 00, 0.4),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
    // return FutureBuilder<GenThumbnailImage>(
    //     future: getThumbnailVideo(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         appLogs("snapshot has data");
    //         if (snapshot.data is GenThumbnailImage)
    //           return SizedBox(
    //             height: MediaQuery.of(context).size.height / 2,
    //             width: MediaQuery.of(context).size.width,
    //             child: Stack(
    //               children: [
    //                 // Image.file(File(
    //                 //     "${snapshot.data.thumbnailRequest.thumbnailPath}")),
    //                 snapshot.data,
    //                 Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         GestureDetector(
    //                           onTap: () async {
    //                             await Navigator.push<dynamic>(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                     builder: (context) => VideoPlayerScreen(
    //                                           data: widget.data,
    //                                           isLocal:
    //                                               widget.data.eMessageType !=
    //                                                       null
    //                                                   ? true
    //                                                   : false,
    //                                         )));
    //                           },
    //                           child: Stack(
    //                             alignment: Alignment.center,
    //                             children: [
    //                               Container(
    //                                 height: 100,
    //                                 width: 100,
    //                                 decoration: BoxDecoration(
    //                                   shape: BoxShape.circle,
    //                                   color: Color.fromRGBO(00, 00, 00, 0.4),
    //                                 ),
    //                                 child: Icon(
    //                                   Icons.play_arrow,
    //                                   color: Colors.white,
    //                                   size: 70,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           );
    //       }
    //       appLogs("snapshot not has data");
    //       return SizedBox(
    //         height: MediaQuery.of(context).size.height / 2,
    //         width: MediaQuery.of(context).size.width,
    //         child: Stack(
    //           children: [
    //             imageLocal??Container(
    //               color: Colors.grey[300],
    //               width: MediaQuery.of(context).size.width,
    //               height: MediaQuery.of(context).size.height,
    //             ),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     GestureDetector(
    //                       onTap: () async {
    //                         await Navigator.push<dynamic>(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (context) => VideoPlayerScreen(
    //                                       data: widget.data,
    //                                       isLocal:
    //                                           widget.data.eMessageType != null
    //                                               ? true
    //                                               : false,
    //                                     )));
    //                       },
    //                       child: Stack(
    //                         alignment: Alignment.center,
    //                         children: [
    //                           Container(
    //                             height: 100,
    //                             width: 100,
    //                             decoration: BoxDecoration(
    //                               shape: BoxShape.circle,
    //                               color: Color.fromRGBO(00, 00, 00, 0.4),
    //                             ),
    //                             child: Icon(
    //                               Icons.play_arrow,
    //                               color: Colors.white,
    //                               size: 70,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     });
  }
}
