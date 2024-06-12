import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String baseUrl = 'http://172.28.69.20:5000';

  Future<void> startVideo(String path) async {
    final response = await http.post(
      Uri.parse('$baseUrl/probeboogy.mp4'),
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
              startVideo('probeboogy.mp4'); // Change this to the actual path
            },
            child: Text('Start Video'),
          ),
        ),
      ),
    );
  }
}
