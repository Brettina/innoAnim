import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String baseUrl = 'localhost';
  final String ip = '172.28.69.20';

  Future<bool> checkServerAvailability() async {
    try {
      final response = await http.get(Uri.parse('http://$ip'));
      return response.statusCode == 200;
    } catch (e) {
      // An error occurred during the request
      return false;
    }
  }

// Method to fetch the list of files from the server
  Future<List<String>> fetchFileList() async {
    final response = await http.get(Uri.parse('$ip:5000/list_files'));
    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> fileList = jsonDecode(response.body);
      // Convert the list of dynamic to list of String
      List<String> files = fileList.map((file) => file.toString()).toList();
      return files;
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load file list');
    }
  }

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

    // Check if the video file exists
    if (response.body == 'Video found') {
      print('Video found successfully');
    } else {
      print('Failed to find video');
    }
  }

  Future<void> printOnServerConsole() async {
    final response = await http.post(
      Uri.parse('$baseUrl/print_text'),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Start Video App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First image from local assets
              Image.asset('image1.png'),
              SizedBox(height: 20),
              // Second image loaded from server
              Image.network(
                '$baseUrl/assetsserv/img1.png', // Adjust the URL according to your server setup
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  startVideo('probeboogy.mp4');
                },
                child: Text('Start Video'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  printOnServerConsole();
                },
                child: Text('Print Text on Server Console'),
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
