import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/utils/open_files/file/file_bloc.dart';
import 'package:module_chat/utils/open_files/file/file_event.dart';
import 'package:module_chat/utils/open_files/file/file_state.dart';
import 'package:module_chat/utils/show_flushbar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FileDownloadPage extends StatefulWidget {
  final BuildContext buildContext;
  final ModelChatMessages data;

  FileDownloadPage({Key key, this.buildContext, this.data}) : super(key: key);

  @override
  _FileDownloadPageState createState() => _FileDownloadPageState();
}

class _FileDownloadPageState extends State<FileDownloadPage> {
  ModelChatMessages modelChatMessages;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    BlocProvider.of<FileBloc>(this.context).dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FileBloc>(this.context)
        .add(FileEventInit(data: widget.data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileBloc, FileState>(
      listener: (context, state) {
        print('state: ${state}');
        if (state is FileStateNotSupportDevice) {
          print(
              'Điện thoại của Ông/bà không có ứng dụng hỗ trợ mở tập tin này');
          showFlushbar(
              ctx: widget.buildContext,
              loaiThongBao: LoaiThongBao.canhBao,
              message:
                  'Điện thoại của Ông/bà không có ứng dụng hỗ trợ mở tập tin này');
        }
      },
      child: BlocBuilder<FileBloc, FileState>(
        builder: (context, state) {
          if (state.data == null) {
            modelChatMessages = widget.data;
          }
          if (state is FileStateFailure) {
            if (state.data != null &&
                state.data.messageID == modelChatMessages.messageID) {
              return Container(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              );
            }
          } else if (state is FileStateProgress) {
            if (state.dataTemp != null &&
                state.dataTemp.messageID == modelChatMessages.messageID) {
              modelChatMessages.showFileDownloadLoading = state.progress;
              return viewDowLoading(
                dataLoading: modelChatMessages.showFileDownloadLoading,
                modelChatMessages: modelChatMessages,
              );
            } else {
              if(modelChatMessages.isShowFileDownload)
                return Container(
                  child: Icon(
                    Icons.download_done_outlined,
                    color: Colors.green,
                  ),
                );
              return Container(
                child: Icon(
                  Icons.download_outlined,
                  color: Colors.black,
                ),
              );
            }
          } else if (state is FileStateInitial) {
            return Container(
              child: Icon(
                Icons.download_outlined,
                color: Colors.black,
              ),
            );
          } else if (state is FileStateStart) {
            if (state.data != null &&
                state.isHasFile &&
                state.data.messageID == modelChatMessages.messageID &&
                state.data.isShowFileDownload)
              modelChatMessages.isShowFileDownload = true;

            if (modelChatMessages.isShowFileDownload) {
              return Container(
                child: Icon(
                  Icons.download_done_outlined,
                  color: Colors.green,
                ),
              );
            } else {
              return Container(
                child: Icon(
                  Icons.download_outlined,
                  color: Colors.black,
                ),
              );
            }
          }
          return Container(
            child: Icon(
              Icons.download_outlined,
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }
}

// ignore: camel_case_types
class viewDowLoading extends StatelessWidget {
  final double dataLoading;
  final ModelChatMessages modelChatMessages;

  viewDowLoading({Key key, this.dataLoading, this.modelChatMessages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ModelChatMessages>(
        stream: BlocProvider.of<FileBloc>(context).outCounter,
        builder:
            (BuildContext context, AsyncSnapshot<ModelChatMessages> snapshot) {
          return Container(
            color: Colors.transparent,
            child: CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 5.0,
              percent:snapshot.data==null ?0.0: snapshot.data.showFileDownloadLoading/ 100.0,
              progressColor: Colors.green,
            ),
          );
        });
  }
}
