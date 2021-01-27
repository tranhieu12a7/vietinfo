import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:module_chat/utils/camera/bloc.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'animation_red_circle.dart';
import 'display_picture_screen.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({Key key, this.camera}) : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  double scale=1.0;

  ModelTimer timer = new ModelTimer();

  BlocCoreCamera blocCoreCamera;
  ModelCameraTakePhotoAndVideo modelCameraTakePhotoAndVideo;

  @override
  void initState() {
    super.initState();

    blocCoreCamera = new BlocCoreCamera();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    blocCoreCamera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    modelCameraTakePhotoAndVideo = new ModelCameraTakePhotoAndVideo();

    return StreamBuilder<ModelCameraTakePhotoAndVideo>(
      stream: blocCoreCamera.getResultTakeAVideoStream,
      builder:
          (context, AsyncSnapshot<ModelCameraTakePhotoAndVideo> snapshotModel) {
        if (snapshotModel.hasData) {
          modelCameraTakePhotoAndVideo = snapshotModel.data;
        }
        return Scaffold(
            // appBar: AppBar(title: Text('Take a picture')),
            // Wait until the controller is initialized before displaying the
            // camera preview. Use a FutureBuilder to display a loading spinner
            // until the controller has finished initializing.
            body: (modelCameraTakePhotoAndVideo.isShowView == false)
                ? Stack(
                    children: [
                      FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // If the Future is complete, display the preview.
                            return GestureDetector(
                                // onScaleUpdate: (value){
                                //   print(scale);
                                //   setState(() {
                                //     if(value.scale>1.0)
                                //     scale=value.scale;
                                //   });
                                // },
                                // onDoubleTap: (){
                                //   setState(() {
                                //       scale=1.0;
                                //   });
                                // },
                                child: Transform.scale(
                                    scale: scale,
                                    child: CameraPreview(_controller)));
                          } else {
                            // Otherwise, display a loading indicator.
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          timeTakeAVideo(
                              timer: timer, blocCoreCamera: blocCoreCamera),

                          ///button take a photo
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Container(
                                color: Colors.transparent,
                                height: 80.0,
                                width: 80.0,
                                child: GestureDetector(
                                  child: Icon(
                                    modelCameraTakePhotoAndVideo.isVideo
                                        ? Icons.videocam_off
                                        : Icons.camera,
                                    color: modelCameraTakePhotoAndVideo.isVideo
                                        ? Colors.red
                                        : Colors.white,
                                    size: 80,
                                  ),
                                  // Provide an onPressed callback.
                                  onTap: () async {
                                    if (!modelCameraTakePhotoAndVideo.isVideo &&
                                        modelCameraTakePhotoAndVideo
                                            .isTakePhoto) {
                                      blocCoreCamera.stopPhotoRecording(
                                          controller: _controller,
                                          context: context,
                                          initializeControllerFuture:
                                              _initializeControllerFuture);
                                    } else {
                                      blocCoreCamera.stopVideoRecording(
                                          controller: _controller,
                                          ctx: context);
                                      await _controller.dispose();
                                    }
                                  },
                                )),
                          ),
                        ],
                      ),

                      ///button take a video
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50, right: 20),
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            child: !modelCameraTakePhotoAndVideo.isVideo
                                ? GestureDetector(
                                    child: Icon(
                                      Icons.videocam,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    // Provide an onPressed callback.
                                    onTap: () async {
                                      // Take the Video in a try / catch block. If anything goes wrong,
                                      try {
                                        blocCoreCamera
                                            .onVideoRecordButtonPressed(
                                                context, _controller);
                                      } catch (e) {
                                        // If an error occurs, log the error to the console.
                                        print(e);
                                      }
                                    },
                                  )
                                : Container(),
                          ),
                        ),
                      ),

                      ///button back page
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Opacity(
                            opacity: 0.5,
                            child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context, "aaaa");
                                }),
                          ),
                        ),
                      ),
                    ],
                  )
                : DisplayPictureScreen(
                    imagePath: modelCameraTakePhotoAndVideo.path,
                    showThumbnail: modelCameraTakePhotoAndVideo.showThumbnail,
                    bloc: blocCoreCamera,
                  ));
      },
    );
  }
}

class timeTakeAVideo extends StatefulWidget {
  ModelTimer timer;
  final BlocCoreCamera blocCoreCamera;

  timeTakeAVideo({Key key, this.timer, this.blocCoreCamera}) : super(key: key);

  @override
  _timeTakeAVideoState createState() => _timeTakeAVideoState();
}

class _timeTakeAVideoState extends State<timeTakeAVideo> {
  @override
  Widget build(BuildContext context) {
    int aaaa = 0;

    return StreamBuilder<ModelTimer>(
      stream: widget.blocCoreCamera.getTimerStream,
      builder: (context, AsyncSnapshot<ModelTimer> snapshot) {
        aaaa += 1;
        print('xxxx ${aaaa}');
        if (snapshot.hasData) {
          widget.timer = snapshot.data;
          return Container(
            width: double.infinity,
            color: Colors.transparent,
            height: MediaQuery.of(context).padding.top + 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  child: AnimationRedCircle(),
                  visible: true,
                ),
                Material(
                    color: Colors.transparent,
                    child: Text(
                      "${widget.timer.hours}:${widget.timer.minutes}:${widget.timer.seconds}",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
