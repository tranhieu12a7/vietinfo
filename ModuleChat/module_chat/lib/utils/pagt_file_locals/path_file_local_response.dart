
// android: getExternalCacheDirectories, getExternalStorageDirectory
// ios : getTemporaryDirectory , getApplicationDocumentsDirectory

import 'dart:io';
import 'dart:io' as io;

import 'package:module_chat/utils/logs.dart';
import 'package:module_chat/utils/pagt_file_locals/path_file_local_datasource.dart';
import 'package:path_provider/path_provider.dart';

class PathFileLocalResponse extends PathFileLocalDataSource {
  @override
  void insertCache() async {}

  @override
  Future<Directory> getPathLocal(EPathType ePathType) async {
    Directory pathDir;
    try {
      if (ePathType == EPathType.Storage) {
        if (Platform.isAndroid) {
          pathDir = (await getExternalStorageDirectories()).first;
        } else if (Platform.isIOS) {
          pathDir = await getApplicationDocumentsDirectory();
        }
      } else {
        if (Platform.isAndroid) {
          pathDir = (await getExternalCacheDirectories()).first;
        } else if (Platform.isIOS) {
          pathDir = await getTemporaryDirectory();
        }
      }
      if (pathDir != null) return pathDir;
      return null;
    } catch (error) {
      appLogs(error);
      return null;
    }
  }

  @override
  Future<String> getPathLocalChat(
      {EPathType ePathType,
      String configPathStr,
      Function functionGetPathStorage}) async {
    Directory directory;
    try {
      if (functionGetPathStorage == null) {
        directory = await getPathLocal(ePathType);
      } else
        directory = functionGetPathStorage.call(ePathType);

      if (directory != null) {
        Directory directoryNew = Directory('${directory.path}/$configPathStr/');
        if (!await directoryNew.exists())
          await directoryNew.create(recursive: true);
        return directoryNew.path;
      }
    } catch (error) {
      appLogs(error);
      return null;
    }
  }

  @override
  Future<bool> checkExistFile({String path}) async {
    if (await io.File(path).exists()) {
      return true;
    } else {
      io.File(path).create(recursive: true);
      return false;
    }
  }
}
