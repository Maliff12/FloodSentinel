// authority_page.dart

import 'package:flutter/material.dart';
import 'reported_report_page.dart'; // Import the ReportedReportPage file
import 'login_page.dart'; // Import the login_page.dart file

class AuthorityPage extends StatefulWidget {
  const AuthorityPage({super.key});

  @override
  State<AuthorityPage> createState() => _AuthorityPageState();
}

class _AuthorityPageState extends State<AuthorityPage> {
  String _selectedLocation = 'Location 1';
  final List<String> _locations = ['Location 1', 'Location 2', 'Location 3'];
  String _waterLevel = 'Normal';
  String _floodPrediction = 'No Flood Predicted';

  void _updateLocation(String? newLocation) {
    setState(() {
      _selectedLocation = newLocation!;
      _waterLevel = 'High';
      _floodPrediction = 'Flood Predicted';
    });
  }

  void _navigateToReportedReportPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportedReportPage()),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authority Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flood Prediction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              items: _locations.map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: _updateLocation,
              decoration: const InputDecoration(
                labelText: 'Select Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Water Level',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(_waterLevel),
            const SizedBox(height: 16.0),
            const Text(
              'Flood Prediction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(_floodPrediction),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                _navigateToReportedReportPage(context);
              },
              child: const Text('Reported Report Page'),
            ),
          ],
        ),
      ),
    );
  }
}
