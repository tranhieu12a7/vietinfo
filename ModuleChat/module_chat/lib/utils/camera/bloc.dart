
import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/utils/camera/gen_thumbnail_image.dart';
import 'package:module_chat/utils/functions.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:module_chat/utils/pagt_file_locals/path_file_local_datasource.dart';
import 'package:path/path.dart';


class BlocCoreCamera {
  StreamController<ModelTimer> _timerStream;
  StreamController<ModelCameraTakePhotoAndVideo> _resultTakeAVideoStream;

  Stream get getTimerStream => _timerStream.stream;

  Stream get getResultTakeAVideoStream => _resultTakeAVideoStream.stream;

  Timer timer;
  Duration timerInterval = Duration(seconds: 1);
  int counter = 0;

  String _hoursStr = '00';
  String _minutesStr = '00';
  String _secondsStr = '00';

  String videoPath,imagePath;

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  GenThumbnailImage showThumbnail;

  ///initialized BlocCoreCamera
  BlocCoreCamera() {
    _timerStream =
        new StreamController<ModelTimer>.broadcast(onCancel: stopTimer);
    _resultTakeAVideoStream =
        new StreamController<ModelCameraTakePhotoAndVideo>();
  }

  ///

  /// timer view
  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
      counter = 0;
    }
  }

  void tick(_) {
    counter++;

    _hoursStr = ((counter / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
    _minutesStr = ((counter / 60) % 60).floor().toString().padLeft(2, '0');
    _secondsStr = (counter % 60).floor().toString().padLeft(2, '0');

    _timerStream.add(new ModelTimer(
        hours: _hoursStr, minutes: _minutesStr, seconds: _secondsStr));
  }

  void startTimerVideo() {
    timer = Timer.periodic(timerInterval, tick);
  }

  ///

  /// dispose all streamController
  void dispose() {
    stopTimer();
    _timerStream.close();
    _resultTakeAVideoStream.close();
  }

  ///

  /// start video
  void onVideoRecordButtonPressed(
      BuildContext ctxMain, CameraController controller) {
    print('onVideoRecordButtonPressed()');
    _resultTakeAVideoStream.sink.add(
        new ModelCameraTakePhotoAndVideo(isTakePhoto: false, isVideo: true));

    startTimerVideo();
    startVideoRecording(ctxMain, controller).then((String filePath) {
      // if (mounted) setState(() {});
      if (filePath != null) _showException('Saving video to $filePath');
    });

    ///
  }

  ///take a video
  Future<String> startVideoRecording(
      BuildContext ctxMain, CameraController controller) async {
    if (!controller.value.isInitialized) {
      return null;
    }
    // final Directory extDir = await getApplicationDocumentsDirectory();
    // final Directory extDir = await getExternalStorageDirectory();
    // final String dirPath = '${extDir.path}/Videos';
    final String dirPath = await getIt
        .get<PathFileLocalDataSource>()
        .getPathLocalChat(
            ePathType: EPathType.cache,
            configPathStr: ConfigData.getPathLocalVideos());
    // await new Directory(dirPath).create(recursive: true);
    final String filePath =
        '$dirPath${ConfigData.getUserID() + timestamp()}.mp4';

    //image local sau khi thumbvideo
    final String dirPathImage = await getIt
        .get<PathFileLocalDataSource>()
        .getPathLocalChat(
        ePathType: EPathType.cache,
        configPathStr: ConfigData.getPathLocalImages());
    // await new Directory(dirPath).create(recursive: true);
    final String filePathImage =
        '$dirPathImage${ConfigData.getUserID() + timestamp()}.png';

    if (controller.value.isRecordingVideo) {
      return null;
    }

    try {
      videoPath = filePath;
      imagePath=filePathImage;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showException(e.description);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording(
      {BuildContext ctx, CameraController controller}) async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }
    try {
      stopTimer();
      await controller.stopVideoRecording();



      showThumbnail = new GenThumbnailImage(
        thumbnailRequest: ThumbnailRequest(
            video: videoPath,
            thumbnailPath: imagePath,
            //imageFormat: ImageFormat.PNG,
            timeMs: 20,
            quality: 100),
        heightImage: MediaQuery.of(ctx).size.height,
        widthImage: MediaQuery.of(ctx).size.width,
        onSubmitted: (Uint8List value) {
          // setState(() {
          //   valueByte = value;
          // });
        },
      );

      // Navigator.push(
      //   ctx,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         DisplayPictureScreen(imagePath: null,showThumbnail: showThumbnail,),
      //   ),
      // );
      _resultTakeAVideoStream.sink.add(ModelCameraTakePhotoAndVideo()
          .cloneWrite(isShowView: true, showThumbnail: showThumbnail));
    } catch (error) {
      return null;
    }
  }

  ///take a photo
  Future<void> stopPhotoRecording(
      {BuildContext context,
      CameraController controller,
      Future<void> initializeControllerFuture}) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await initializeControllerFuture;

      // Construct the path where the image should be saved using the
      // pattern package.
      String uri = await getIt.get<PathFileLocalDataSource>().getPathLocalChat(
          ePathType: EPathType.cache,
          configPathStr: ConfigData.getPathLocalImages());
      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        uri,
        '${ConfigData.getUserID() + CoreFunctions.convertDateTime(datetime: DateTime.now(), typeDateTime: TypeDateTime.HHmmssddMMyyyy)}.png',
      );

      print(path);

      // Attempt to take a picture and log where it's been saved.
      await controller.takePicture(path);
      // If the picture was taken, display it on a new screen.
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         DisplayPictureScreen(imagePath: path),
      //   ),
      // );

      _resultTakeAVideoStream.sink.add(ModelCameraTakePhotoAndVideo()
          .cloneWrite(isShowView: true, path: path));
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  ///rollback if not like image or video just you want
  void rollback({BuildContext context}) {
    _resultTakeAVideoStream.sink
        .add(ModelCameraTakePhotoAndVideo().cloneWrite(isShowView: false));
  }

  void _showException(String error) {
    appLogs(error);
    // showSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class ModelCameraTakePhotoAndVideo {
  String path;
  bool isVideo;
  bool isTakePhoto;
  bool isShowView;
  GenThumbnailImage showThumbnail;

  ModelCameraTakePhotoAndVideo(
      {this.path,
      this.showThumbnail,
      this.isTakePhoto = true,
      this.isVideo = false,
      this.isShowView = false});

  ModelCameraTakePhotoAndVideo cloneWrite(
      {path, showThumbnail, isTakePhoto, isVideo, isShowView}) {
    return new ModelCameraTakePhotoAndVideo(
      path: path ?? this.path,
      isShowView: isShowView ?? this.isShowView,
      isTakePhoto: isTakePhoto ?? this.isTakePhoto,
      isVideo: isVideo ?? this.isVideo,
      showThumbnail: showThumbnail ?? this.showThumbnail,
    );
  }
}

class ModelTimer {
  String hours;
  String minutes;
  String seconds;

  ModelTimer({this.hours = "00", this.minutes = "00", this.seconds = "00"});
}

class ThumbnailRequest {
  final String video;
  final String thumbnailPath;
  Image image;
  final ImageFormat imageFormat;
  final int maxHeight;
  final int maxWidth;
  final int timeMs;
  final int quality;

  ThumbnailRequest(
      {this.video,
      this.thumbnailPath,
      this.imageFormat,
      this.maxHeight,
      this.maxWidth,
      this.timeMs,
      this.quality});
}

class ThumbnailResult {
  final Image image;
  final int dataSize;
  final int height;
  final int width;

  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}
