import 'package:module_chat/models/model_chat_messages.dart';

class FileState {
  ModelChatMessages data;
}

class FileStateFailure extends FileState {
  FileStateFailure clone({data}) {
    this.data = data;
    return FileStateFailure();
  }
}

class FileStateInitial extends FileState {}

class FileStateStart extends FileState {
  final bool isHasFile;

  FileStateStart({this.isHasFile});

  FileStateStart clone({isHasFile, data}) {
    this.data = data;
    return FileStateStart(isHasFile: isHasFile);
  }
}

class FileStateProgress extends FileState {
  final double progress;
  ModelChatMessages dataTemp;

  FileStateProgress({this.dataTemp, this.progress});

  FileStateProgress clone({filePath, progress, data}) {
    return FileStateProgress(
        dataTemp: data, progress: progress ?? this.progress);
  }
}

class FileStateSuccessFul extends FileState {}

class FileStateNotSupportDevice extends FileState {}
