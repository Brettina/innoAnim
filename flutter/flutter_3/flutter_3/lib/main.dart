import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Webcam and Video Player')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 240, // Fixed height for the camera feed panel
                child: CameraFeedWidget(cameras: cameras),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Functionality removed for simplicity
                  // startVideo('billoraeder einseitig.mp4');
                },
                child: Text('Start Video'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Functionality removed for simplicity
                  // playVideo(context, 'billoraeder alle.mp4');
                },
                child: Text('Play Video'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Placeholder for button functionality
                },
                child: Text('Button 1'), // Empty button 1
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Placeholder for button functionality
                },
                child: Text('Button 2'), // Empty button 2
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CameraFeedWidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraFeedWidget({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraFeedWidgetState createState() => _CameraFeedWidgetState();
}

class _CameraFeedWidgetState extends State<CameraFeedWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0], // Use the first available camera
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
