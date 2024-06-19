import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

// Define the server address as a constant
const String serverAddress = 'http://172.28.69.28:8080'; // Flask server address

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Webcam and Video Player')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Commenting out the camera feed panel
              // Container(
              //   height: 240, // Fixed height for the camera feed panel
              //   child: CameraFeedWidget(),
              // ),
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
                  _launchURL('$serverAddress/lib/index.html');
                },
                child: Text('Open HTML Video Player'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _helloworld,
                child: Text('Start HelloWorld Method'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _processImage,
                child: Text('Process Image with OpenCV'),
              ),
              SizedBox(height: 20),
              _image != null ? Image.memory(_image!) : Container(),
            ],
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

  void _helloworld() async {
    try {
      final url = Uri.parse('$serverAddress/hello_world');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('HelloWorld method executed successfully');
      } else {
        print('Failed to execute HelloWorld method: ${response.statusCode}');
      }
    } catch (e) {
      print('Error executing HelloWorld method: $e');
    }
  }

  void _processImage() async {
    try {
      final url = Uri.parse('$serverAddress/process_image');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _image = response.bodyBytes;
        });
        print('Image processed successfully');
      } else {
        print('Failed to process image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error processing image: $e');
    }
  }
}

// Commenting out the CameraFeedWidget class
// class CameraFeedWidget extends StatefulWidget {
//   @override
//   _CameraFeedWidgetState createState() => _CameraFeedWidgetState();
// }

// class _CameraFeedWidgetState extends State<CameraFeedWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Camera feed not available'),
//     );
//   }
// }
