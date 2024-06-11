import 'package:flutter/material.dart';
import 'functionsextra.dart';

void main() {
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(erste()), // Pass the result of erste() directly to the Text widget
        ),
      ),
    );
  }
}
