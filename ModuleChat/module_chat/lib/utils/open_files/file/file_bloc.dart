import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/service/files/file_datasource.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:module_chat/utils/open_files/file/file_state.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'file_event.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(FileStateInitial());

  StreamController<ModelChatMessages> controller =
      StreamController<ModelChatMessages>.broadcast();

  Stream<ModelChatMessages> get outCounter => controller.stream;

  StreamSink<ModelChatMessages> get outCounterSink => controller.sink;

  void dispose() {
    controller.close();
  }

  Future<FileState> callCheckFileInit({ModelChatMessages data}) async {
    try {
      // appLogs("callFileStart");

      Directory dirPath = (await getExternalStorageDirectories(
              type: StorageDirectory.downloads))
          .first;
      String link = data.message;
      String nameFile = link.split("/").last;
      final filePath = dirPath.path + "/" + nameFile;
      File file = new File(filePath);
      if (file.existsSync()) {
        if ((await file.readAsBytes()).length > 0) {
          data.isShowFileDownload=true;
          return FileStateStart().clone(data: data,isHasFile: true);
        }
      }
      data.isShowFileDownload=false;
      return FileStateStart().clone(data: data,isHasFile: false);
    } catch (error) {
      appLogs("callCheckFileInit- ${error}");
      return FileStateFailure();
    }
  }

  @override
  Stream<FileState> mapEventToState(FileEvent event) async* {
    if (event is FileEventInit) {
      yield await callCheckFileInit(data: event.data);
    } else if (event is FileEventStartDownload) {
      // yield FileStateProgress(progress: 0.0);
      yield FileStateProgress().clone(data: event.data,progress: 0.0);
      String savePath;
      try{
         savePath = await GetIt.instance<FileDataSource>().DownloadFiles(
            event.data.message, showDownloadProgress: (received, total) {
          if (total != -1) {
            double value = (received / total * 100.0);
            event.data.showFileDownloadLoading = value;
            event.data.isShowFileDownload = value == 100 ? true : false;
            outCounterSink.add(event.data);
          }
        });
         if(savePath==null)
           savePath= event.data.message;
      }catch(error){
        savePath= event.data.message;
        appLogs("FileEventStartDownload - ${error}");
      }
      var resultType = await OpenFile.open(savePath);
      if (resultType.type == ResultType.done) {
        yield FileStateStart().clone(data: event.data,isHasFile: true);

        // appLogs('Mo ung dung thanh cong');
      } else if (resultType.type == ResultType.noAppToOpen) {
        yield FileStateStart().clone(data: event.data,isHasFile: true);
        // appLogs('resultType.type: ${resultType.type}');
        // appLogs('Không có ứng dụng để mở');
      } else if (resultType.type == ResultType.error||resultType.type==ResultType.fileNotFound) {
        // appLogs('Mở file bị lỗi');
        yield FileStateFailure().clone(data: event.data);
      }
    }
  }
}
