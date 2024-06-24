import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:camera/camera.dart';

const String pythonServerAddress =
    'http://localhost:5000'; // Replace with your Python server address

Future<void> callHelloWorld() async {
  try {
    final response = await http.get(Uri.parse('$pythonServerAddress/hello'));
    if (response.statusCode == 200) {
      print('Response from Python server: ${response.body}');
    } else {
      print('Failed to call hello_world. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to call hello_world. Error: $e');
  }
}

Future<void> openImage() async {
  try {
    final response = await http.get(Uri.parse('$pythonServerAddress/img'));
    if (response.statusCode == 200) {
      print('Image opened successfully');
    } else {
      print('Failed to open image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to open image. Error: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(cameras: cameras),
    );
  }
}

class ThreeDRenderer extends StatelessWidget {
  final String modelUrl;
  final List<CameraDescription> cameras;

  const ThreeDRenderer(
      {Key? key, required this.modelUrl, required this.cameras})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('3D Animation')),
      body: Center(
        child: Text('Replace this with your 3D rendering widget'),
      ),
    );
  }
}

class CameraFeed extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraFeed({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraFeedState createState() => _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0], // Use the first camera in the list
      ResolutionPreset.medium,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CameraPreview(_controller), // Display camera preview
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyHomePage({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello World App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Stack(
                children: [
                  ThreeDRenderer(
                    modelUrl:
                        'assets/billo_raddrehen.glb', // Replace with your 3D model URL
                    cameras: cameras, // Pass cameras here
                  ),
                  CameraFeed(cameras: cameras),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Hello from Flutter app!');
              },
              child: Text('Flutter Hello'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: callHelloWorld,
              child: Text('Call Python HelloWorld'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: openImage,
              child: Text('Open Image'),
            ),
          ],
        ),
      ),
    );
  }
}
