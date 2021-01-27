

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:module_chat/utils/pagt_file_locals/path_file_local_datasource.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'bloc.dart';




class GenThumbnailImage extends StatefulWidget {
  ThumbnailRequest thumbnailRequest;
  final double heightImage;
  final double widthImage;

  final Function(Uint8List) onSubmitted;

   GenThumbnailImage({Key key,
    this.thumbnailRequest,
    this.heightImage,
    this.widthImage,
    this.onSubmitted})
      : super(key: key);

  @override
  _GenThumbnailImageState createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  Uint8List uint8list;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<ThumbnailResult>(
        future: genThumbnail(widget.thumbnailRequest,
            height: widget.heightImage,
            width: widget.widthImage,
            onFunctionSubmitted: widget.onSubmitted),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final _image = snapshot.data.image;
            widget.thumbnailRequest.image=snapshot.data.image;
            return Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: _image,
            );
          } else if (snapshot.hasError) {
            return Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.red,
              child: Text(
                "Error:\n${snapshot.error.toString()}",
              ),
            );
          } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ]);
          }
        },
      ),
    );
  }
}

Future<ThumbnailResult> genThumbnail(ThumbnailRequest request,
    {double height,
      double width,
      Function(Uint8List) onFunctionSubmitted}) async {
  //WidgetsFlutterBinding.ensureInitialized();

  Uint8List bytes;
  final Completer<ThumbnailResult> completer = Completer();
  try{
    if (request.thumbnailPath != null) {
      File file;
      int _imageDataSize;
      bool isCheckFile=await getIt.get<PathFileLocalDataSource>().checkExistFile(path: request.thumbnailPath);
      if(isCheckFile){
        // appLogs("not thumbnail - ${request.thumbnailPath}");
         file = File(request.thumbnailPath);
         _imageDataSize  = (await file.readAsBytes()).length;
        if(_imageDataSize==0){
          // appLogs("thumbnail - $_imageDataSize - ${request.video}");

          final thumbnailPath = await VideoThumbnail.thumbnailFile(
              video: request.video,
              thumbnailPath: request.thumbnailPath,
              timeMs: request.timeMs,
              quality: request.quality);
          file=File(thumbnailPath);
          _imageDataSize  = (await file.readAsBytes()).length;
        }
      }
      else{
        // appLogs("thumbnail - ${request.thumbnailPath}");
        // appLogs("thumbnail - ${request.video}");

        final thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: request.video,
            thumbnailPath: request.thumbnailPath,
            //imageFormat: r.imageFormat.raw,
            // maxHeight: request.maxHeight,
            // maxWidth: request.maxWidth,
            timeMs: request.timeMs,
            quality: request.quality);
         file = File(thumbnailPath);
        _imageDataSize  = (await file.readAsBytes()).length;
      }

      final _image = Image.file(
        file,
        fit: BoxFit.fill,
      );
      _image.image
          .resolve(ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(ThumbnailResult(
            image: _image,
            dataSize:  _imageDataSize,
            height: height.toInt(),
            width: width.toInt()));
      }));
      return completer.future;

    }
    else {
      try {
        bytes = await VideoThumbnail.thumbnailData(
            video: "${request.video}",
            // maxWidth: request.maxWidth,
            imageFormat: ImageFormat.PNG,
            // maxHeight: request.maxHeight,
            timeMs: request.timeMs,
            quality: request.quality);
      }
      catch (error) {
        appLogs(error);
      }
    }
  }catch(error){
    appLogs(error);
  }

  int _imageDataSize = bytes.length;
  // print("image size: $_imageDataSize byte" );

  final _image = Image.memory(
    bytes,
    fit: BoxFit.fill,
  );

  onFunctionSubmitted?.call(bytes);

  _image.image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(ThumbnailResult(
        image: _image,
        dataSize: _imageDataSize,
        height: height.toInt(),
        width: width.toInt()));
  }));
  return completer.future;
}
