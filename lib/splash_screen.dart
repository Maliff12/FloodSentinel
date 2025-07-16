import 'package:flutter/material.dart';
import 'login_page.dart'; // Import LoginPage for navigation

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to LoginPage after a delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/logo.png', height: 200), // Adjust image path and size as needed
            SizedBox(height: 20),
            CircularProgressIndicator(), // Optional: Add a loading indicator
          ],
        ),
      ),
    );
  }
}
