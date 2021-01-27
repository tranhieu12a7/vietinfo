import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/config/config_setting.dart';
import 'package:module_chat/models/model_chat_messages.dart';
import 'package:module_chat/service/files/file_datasource.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:module_chat/utils/pagt_file_locals/path_file_local_datasource.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final ModelChatMessages data;
  final bool isLocal;

  const VideoPlayerScreen({Key key, this.data, this.isLocal}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  StreamController reloadButton;


  @override
  void initState() {
    super.initState();

    reloadButton=new  StreamController();
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    if (widget.isLocal) {
      _controller = VideoPlayerController.file(File(widget.data.message));
    } else {
      _controller = VideoPlayerController.network(
        !widget.data.message.contains(ConfigData.getUrlWeb())
            ? ConfigData.getUrlWeb() + widget.data.message
            : widget.data.message,
      );
    }

  }

  Future<dynamic> downloadVideo() async {
    try {
      final String dirPathVideo = await getIt
          .get<PathFileLocalDataSource>()
          .getPathLocalChat(
              ePathType: EPathType.cache,
              configPathStr: ConfigData.getPathLocalVideos());
      String nameFileVideo = widget.data.message.split("/").last;
      String filePathVideo = dirPathVideo;
      String pathResult;
      if(File(dirPathVideo+nameFileVideo).existsSync()){
        pathResult=dirPathVideo+nameFileVideo;
        _controller = VideoPlayerController.file(File(pathResult));
      }else{
        if(widget.data.isDownload==null || widget.data.isDownload==false){
          widget.data.isDownload=true;
          GetIt.instance<FileDataSource>().DownloadFiles(
              !widget.data.message.contains(ConfigData.getUrlWeb())
                  ? ConfigData.getUrlWeb() + widget.data.message
                  : widget.data.message,
              pathFolderFile: filePathVideo).then((value) => appLogs("downloadVideo successful - $value"));
        }
      }

      // Initialize the controller and store the Future for later use.
      _initializeVideoPlayerFuture = _controller.initialize();

      // Use the controller to loop the video.
      _controller.setLooping(true);

      return _initializeVideoPlayerFuture;
    } catch (error) {
      // Initialize the controller and store the Future for later use.
      _initializeVideoPlayerFuture = _controller.initialize();

      // Use the controller to loop the video.
      _controller.setLooping(true);
      return _initializeVideoPlayerFuture;
    }
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('video'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: FutureBuilder(
            future: downloadVideo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          // setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
            reloadButton.sink.add("event");
          // });
        },
        // Display the correct icon depending on the state of the player.
        child: StreamBuilder<Object>(
          stream: reloadButton.stream,
          builder: (context, snapshot) {
            return Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            );
          }
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
