import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:url_launcher/url_launcher.dart';

// Define the server address as a constant
const String serverAddress = 'http://172.28.69.28:8080/';

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
        body: SingleChildScrollView(
          child: Center(
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
                    _launchImageInBrowser('$serverAddress/assets/image1.png');
                  },
                  child: Text('Picture from Server'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _launchURL('$serverAddress/lib/');
                  },
                  child: Text('Open html video player'), // Button 2
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchImageInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
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

Future<void> fetchAndDisplayFiles(BuildContext context) async {
  // Implement your file fetching logic here
}
