import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Server address
const String pythonServerAddress = 'http://localhost:5000'; // Python server

Future<void> callHelloWorld() async {
  try {
    final response = await http.get(Uri.parse('$pythonServerAddress/hell'));
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
    //if (response.statusCode == 200) {
    // print('Image opened successfully');
    // Handle the image data here if needed
    ////} else {
    // print('Failed to open image. Status code: ${response.statusCode}');
    // }
  } catch (e) {
    print('Failed to open image. Error: $e');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
                print('Hello from flutter app!');
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
