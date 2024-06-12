import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp());

  runApp(MainApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final String baseUrl = 'http://127.0.0.1:9102';

  Future<void> startVideo(String path) async {
    final response = await http.post(
      Uri.parse('$baseUrl/start_video'),
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Start Video App')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              startVideo(
                  'assets/probeboogy.mp4'); // Change this to the actual path
            },
            child: Text('Start Video'),
          ),
        ),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  final CameraDescription camera;

  const MainApp({Key? key, required this.camera}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  TextEditingController velocityController = TextEditingController();
  String velocityValue = '';
  bool _measuringSpeed = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    velocityController.dispose();
    super.dispose();
  }

  Future<void> firePythonHttpMethod() async {
    final response = await http
        .post(Uri.parse('http://your-python-server-url/python_http_method'));
    if (response.statusCode == 200) {
      print('Python method executed successfully');
    } else {
      print('Failed to execute Python method');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Horizontal Panels Example'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PanelWidget(
                  buttonText: 'info',
                  showImage: true,
                  showWebView: true,
                ),
                PanelWidget(
                  buttonText: 'python http',
                  showImage: false,
                  onPressed: firePythonHttpMethod,
                ),
                PanelWidget(
                  buttonText:
                      _measuringSpeed ? 'Measuring speed' : 'Measure speed',
                  showImage: false,
                  onPressed: () {
                    setState(() {
                      _measuringSpeed = !_measuringSpeed;
                    });
                  },
                ),
                CameraPanel(
                  camera: widget.camera,
                  controller: _controller,
                  initializeControllerFuture: _initializeControllerFuture,
                  velocityValue: velocityValue,
                ),
                PanelWidget(
                  buttonText: 'start engine',
                  hintText: 'enter velocity',
                  showImage: false,
                  showTextField: true,
                  velocityController: velocityController,
                  onTextChanged: (value) {
                    setState(() {
                      velocityValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PanelWidget extends StatelessWidget {
  final String buttonText;
  final String? hintText;
  final bool showImage;
  final bool showTextField;
  final bool showWebView;
  final TextEditingController? velocityController;
  final ValueChanged<String>? onTextChanged;
  final VoidCallback? onPressed;

  const PanelWidget({
    required this.buttonText,
    this.hintText,
    this.showImage = true,
    this.showTextField = false,
    this.showWebView = false,
    this.velocityController,
    this.onTextChanged,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (showImage)
          Image.asset(
            'image1.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
        const SizedBox(width: 8.0),
        if (showTextField)
          SizedBox(
            width: 100,
            child: TextField(
              controller: velocityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: hintText,
              ),
              onChanged: onTextChanged,
            ),
          ),
        if (showWebView)
          Container(
            width: 100,
            height: 100,
            child: WebView(
              initialUrl: 'https://www.google.com',
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
      ],
    );
  }
}

class CameraPanel extends StatelessWidget {
  final CameraDescription camera;
  final CameraController controller;
  final Future<void> initializeControllerFuture;
  final String velocityValue;

  const CameraPanel({
    Key? key,
    required this.camera,
    required this.controller,
    required this.initializeControllerFuture,
    required this.velocityValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<void>(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Text(
          'Velocity: $velocityValue km/h',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
