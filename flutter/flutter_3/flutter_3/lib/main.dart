import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String serverAddress =
    'http://localhost:8080'; // Replace with your server IP

void main() {
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

class MainScreen extends StatelessWidget {
  Future<void> _callPythonHelloWorld() async {
    try {
      final url = Uri.parse('$serverAddress/open_image');
      final response = await http.get(url).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        print('Python method executed successfully');
      } else {
        print('Failed to execute Python method: ${response.statusCode}');
      }
    } catch (e) {
      print('Error executing Python method: $e');
    }
  }

  Future<void> _openImageWithOpenCV() async {
    try {
      final url = Uri.parse('$serverAddress/open_image');
      final response = await http.get(url).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        print('Image opened successfully with OpenCV');
        // Display the image in Flutter (implement as needed)
      } else {
        print('Failed to open image with OpenCV: ${response.statusCode}');
      }
    } catch (e) {
      print('Error opening image with OpenCV: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello World App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print('Hello, World!');
              },
              child: Text('Say Hello'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _callPythonHelloWorld,
              child: Text('Call Python HelloWorld'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openImageWithOpenCV,
              child: Text('Open Image with OpenCV'),
            ),
          ],
        ),
      ),
    );
  }
}
