import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({required this.cameras});

  final String baseUrl = 'localhost';

  Future<bool> checkServerAvailability() async {
    try {
      final response = await http.get(Uri.parse('http://$baseUrl:8000'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> fetchFileList() async {
    final response = await http.get(Uri.parse(
        'http://$baseUrl:8000/list_files')); // Modified URL to point to the proxy server
    if (response.statusCode == 200) {
      List<dynamic> fileList = jsonDecode(response.body);
      List<String> files = fileList.map((file) => file.toString()).toList();
      return files;
    } else {
      throw Exception('Failed to load file list');
    }
  }

  Future<void> startVideo(String path) async {
    final response = await http.post(
      Uri.parse(
          'http://$baseUrl:8000/start_video'), // Modified URL to point to the proxy server
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'path': path,
      }),
    );

    if (response.statusCode == 200) {
      print('Video started successfully');
    } else {
      print('Failed to start video: ${response.body}');
    }

    if (response.body == 'Video found') {
      print('Video found successfully');
    } else {
      print('Failed to find video');
    }
  }

  Future<void> printOnServerConsole() async {
    final response = await http.post(
      Uri.parse(
          'http://$baseUrl:8000/print_text'), // Modified URL to point to the proxy server
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'text': 'Hello from Flutter App!',
      }),
    );

    if (response.statusCode == 200) {
      print('Text printed successfully on server console');
    } else {
      print('Failed to print text on server console: ${response.body}');
    }
  }

  Future<void> testServerConnection() async {
    try {
      final isServerAvailable = await checkServerAvailability();
      print('Server is available: $isServerAvailable');
    } catch (e) {
      print('Failed to connect to server: $e');
    }
  }

  Future<void> playVideo(String videoPath) async {
    // Implement your play_video method here using the videoPath parameter
    // For example, you can use the video_player package to play the video
    // Make sure to replace this placeholder with your actual implementation
    print('Playing video: $videoPath');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Start Video App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 240, // Set a fixed height for the camera feed panel
                child: CameraFeedWidget(cameras: cameras),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  startVideo('/assets');
                },
                child: Text('Start Video'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  playVideo('probeboogy.mp4'); // Replace with actual path
                },
                child: Text('Play Video'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    List<String> fileList = await fetchFileList();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('List of Files'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: fileList
                                  .map((file) => ListTile(title: Text(file)))
                                  .toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    print('Error: $e');
                  }
                },
                child: Text('Get List of Files'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  testServerConnection();
                },
                child: Text('Test Server Connection'),
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
