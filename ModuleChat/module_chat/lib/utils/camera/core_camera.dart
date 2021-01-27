import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:module_chat/cores/chat_bloc.dart';
import 'package:module_chat/utils/functions.dart';

import 'bloc.dart';
import 'take_picture_screen.dart';

class CoreCamera {
  static CameraDescription _firstCamera;

  static void initializedCamera() async {
    ///initialized camera
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    _firstCamera = cameras.first;
    ///
  }

  // ignore: missing_return
  static Future<void> openCamera(
      BuildContext context, Function callBack) async {
    var dataResuilt = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                  camera: _firstCamera,
                )));
    var modelResult = dataResuilt as ModelCameraTakePhotoAndVideo;
    dynamic param ;
    if(modelResult!=null){
      if (modelResult.path != null) {
        param = {
          ChatBloc.messagesTypeParam: EMessagesType.image,
          ChatBloc.messagesParam: modelResult.path
        };
      }
      else{
        if(modelResult.showThumbnail.thumbnailRequest!=null){
          param = {
            ChatBloc.messagesTypeParam: EMessagesType.video,
            ChatBloc.messagesParam: modelResult.showThumbnail.thumbnailRequest.video,
            ChatBloc.thumbnailParam: modelResult.showThumbnail
          };
        }
      }
      callBack.call(param);
    }
  }
}
