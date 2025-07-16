import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'splash_screen.dart'; // Import SplashScreen to start with

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Customize your theme as needed
      ),
      home: SplashScreen(), // Start with SplashScreen
    );
  }
}
