import 'package:flutter/material.dart';
import 'functionsextra.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vertical Panels Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Upmost Panel
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(erste()), // Display text from erste() method
                ],
              ),
            ),
            // Middle Panel - Placeholder for Camera Feed
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.green,
                // Placeholder for the camera feed
                child: Center(
                  child: Text(
                    'Camera Feed Placeholder',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
            ),
            // Lowest Panel
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.orange,
                child: VelocityInformation(), // Display velocity information
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to display velocity information
class VelocityInformation extends StatefulWidget {
  @override
  _VelocityInformationState createState() => _VelocityInformationState();
}

class _VelocityInformationState extends State<VelocityInformation> {
  TextEditingController _velocityController = TextEditingController();
  double _velocity = 20.0; // Default velocity

  @override
  void dispose() {
    _velocityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Velocity: $_velocity km/h', // Display current velocity
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {},
          child: Text('Start Engine'),
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: _velocityController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter Velocity',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              // Update velocity value dynamically based on user input
              _velocity = double.tryParse(value) ?? _velocity;
            });
          },
        ),
      ],
    );
  }
}
