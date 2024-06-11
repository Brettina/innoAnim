import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart'; // Import the camera package

import 'package:flutter_inno/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Get a list of available cameras
    final cameras = await availableCameras();

    // Define a dummy CameraDescription instance
    final dummyCamera = CameraDescription(
      name: 'dummy_camera', // Provide a name for the dummy camera
      lensDirection: CameraLensDirection.front, // Choose a lens direction
      sensorOrientation: 0, // Provide a dummy sensor orientation value
    );

    // Build our app and trigger a frame.
    // Pass the first camera in the list as the dummy camera
    await tester.pumpWidget(MyApp(camera: cameras.first));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
