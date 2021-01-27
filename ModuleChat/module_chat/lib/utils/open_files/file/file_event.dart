import 'package:module_chat/models/model_chat_messages.dart';

class FileEvent {
    ModelChatMessages data;
}

class FileEventInit extends FileEvent {
  FileEventInit({data}){
    this.data=data;
  }
}

class FileEventStartDownload extends FileEvent {
  FileEventStartDownload({data}){
    this.data=data;
  }
}
