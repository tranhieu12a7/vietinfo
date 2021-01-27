import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:module_chat/cores/chat_bloc.dart';
import 'package:module_chat/utils/camera/core_camera.dart';
import 'package:module_chat/utils/functions.dart';
import 'package:module_chat/utils/logs.dart';

import 'core_file_datasource.dart';

class CoreFileResponse extends CoreFileDataSource {
  @override
  Future<void> takeAlbums({BuildContext context, Function callBack}) async {
    try{
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowCompression: true,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'png'],
      );
      if (result != null && result.files.length > 0) {
       int messageIDGroup= ChatBloc.modelMessagesCurrent.first.messageID;
        for (var item in result.files) {
          if (item.path != null) {
            dynamic param = {
              ChatBloc.messagesTypeParam: EMessagesType.image,
              ChatBloc.messagesParam: item.path,
              ChatBloc.messagesIDGroupParam : messageIDGroup
            };
            callBack?.call(param);
          }
        }
      }
    }catch(error){
      appLogs("takeAlbums - ${error}");
    }
  }

  @override
  Future<void> takeFiles({BuildContext context, Function callBack}) async{
   try{
     FilePickerResult result = await FilePicker.platform.pickFiles(
       type: FileType.custom,
       allowMultiple: false,
       allowedExtensions: ['xlsx', 'pdf', 'doc'],
       // allowedExtensions: ['*/*'],
     );
     if (result != null && result.files.length > 0) {
       for (var item in result.files) {
         if (item.path != null) {
           dynamic param = {
             ChatBloc.messagesTypeParam: EMessagesType.file,
             ChatBloc.messagesParam: item.path.replaceAll(" ", "%20")
           };
           callBack?.call(param);
         }
       }
     }
   }catch(error){
     appLogs("takeFiles - ${error}");
   }
  }

  @override
  Future<void> takePhoto({BuildContext context, Function callBack}) {
    CoreCamera.openCamera(context, callBack);
  }

  @override
  Future<void> takeVideo({BuildContext context, Function callBack}) {
    CoreCamera.openCamera(context, callBack);
  }
}
