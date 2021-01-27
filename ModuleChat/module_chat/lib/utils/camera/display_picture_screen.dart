import 'dart:io';

import 'package:flutter/material.dart';
import 'package:module_chat/utils/camera/bloc.dart';

import 'gen_thumbnail_image.dart';





class DisplayPictureScreen extends StatefulWidget {

  final GenThumbnailImage showThumbnail;
  final String imagePath;
  final BlocCoreCamera bloc;

  const DisplayPictureScreen({Key key, this.imagePath, this.showThumbnail,this.bloc})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
        body: Stack(
          children: [
            widget.showThumbnail != null
                ? Stack(
              children: [
                Container(
                  child: widget.showThumbnail,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
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
                            ],
                          ),
                          onTap: () {
                            // viewMedia(
                            //     pathFile: videoPath,
                            //     typeFile: 'mp4',
                            //     context: context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
                : Container(
                color: Colors.black,
                child: Center(child: Image.file(File(widget.imagePath)))),
            ///button back page
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      widget.bloc?.rollback(context: context);
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0)
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context, new ModelCameraTakePhotoAndVideo(path:widget.imagePath,showThumbnail: widget.showThumbnail));
                    },
                    child: Icon(
                      Icons.send,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

