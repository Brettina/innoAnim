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
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(erste()), // Display text from erste() method
                ],
              ),
            ),
            // Middle Panel - Camera Feed
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.green,
                // Show real camera feed
                child: CameraFeed(),
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

// Widget to display camera feed
class CameraFeed extends StatefulWidget {
  @override
  _CameraFeedState createState() => _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Obtain a list of the available cameras
    availableCameras().then((cameras) {
      // Get the first camera from the list
      CameraDescription firstCamera = cameras.first;
      // Initialize the camera controller
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
      // Initialize the controller future
      _initializeControllerFuture = _controller.initialize();
      // Update the state
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If the controller is not initialized, display a loading spinner
    if (_controller == null || !_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    // Return the CameraPreview widget to display the camera feed
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
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
          onPressed: () {
          start_engine();
          },
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