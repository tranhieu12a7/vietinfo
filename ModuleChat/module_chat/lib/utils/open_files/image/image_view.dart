
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewScreen extends StatefulWidget {
  final ModelChatMessages data;
  final List<ModelChatMessages> datas;
  final bool isLocal;

  const ImageViewScreen({Key key, this.data, this.datas, this.isLocal})
      : super(key: key);

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  final controller = PhotoViewController();
   List<ModelChatMessages> _listImage;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listImage=widget.datas;
  }

  @override
  Widget build(BuildContext context) {
    appLogs("onPageChanged1 ${_listImage.first.message}");

    return Scaffold(
      appBar: AppBar(
        title: Text('image'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: _listImage != null
                ? PhotoViewGallery.builder(
                    itemCount: _listImage.length,
                    pageController: PageController(
                        initialPage: _listImage.indexWhere((element) =>
                            element.message.contains(widget.data.message))),
                    onPageChanged: (value) {
                      appLogs("onPageChanged ${_listImage[value].message}");
                    },
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                          imageProvider: widget.isLocal
                              ? FileImage(
                                  File(getLinkImage(_listImage[index])))
                              : NetworkImage(getLinkImage(_listImage[index])),
                          initialScale: PhotoViewComputedScale.contained * 1.0,
                          maxScale: 2.0,
                          minScale: PhotoViewComputedScale.contained * 1.0,
                          heroAttributes: PhotoViewHeroAttributes(tag: index));
                    },
                    loadingBuilder: (context, event) => Center(
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null
                              ? 0
                              : event.cumulativeBytesLoaded /
                                  event.expectedTotalBytes,
                        ),
                      ),
                    ),
                  )
                : PhotoView(
                    maxScale: 2.0,
                    minScale: PhotoViewComputedScale.contained * 1.0,
                    initialScale: PhotoViewComputedScale.contained * 1.0,
                    basePosition: Alignment.center,
                    imageProvider: widget.isLocal
                        ? FileImage(File(getLinkImage(widget.data)))
                        : NetworkImage(getLinkImage(widget.data)))),
      ),
    );
  }

  String getLinkImage(ModelChatMessages data) {
    if (widget.isLocal) return data.message;
    return !data.message.contains(ConfigData.getUrlWeb())
        ? ConfigData.getUrlWeb() + data.message.replaceAll("Caches", "Files")
        : data.message.replaceAll("Caches", "Files");
  }
}
