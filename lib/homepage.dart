import 'package:floodsentinel/complain_page.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'manage_profile_page.dart';
import 'login_page.dart';
import 'water_level_insert.dart';
import 'reported_report_page.dart';
import 'database_helper.dart'; // Ensure this import matches your actual file naming

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> waterLevelData = [];

  @override
  void initState() {
    super.initState();
    _fetchWaterLevelData();
  }

  Future<void> _fetchWaterLevelData() async {
    // Fetch water level data from the database
    List<Map<String, dynamic>> data = await DatabaseHelper().getAllWaterLevels();
    setState(() {
      waterLevelData = data;
    });
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage on logout
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
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
                Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Manage Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageProfilePage(username: widget.username),
                  ),
                );
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Water Level Indicator Feature
            WaterLevelIndicator(waterLevelData: waterLevelData),

            // Complain Filing Feature
            ComplainFiling(),

            // Button to navigate to WaterLevelInsertPage
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaterLevelInsertPage()),
                ).then((_) => _fetchWaterLevelData()); // Fetch data again after returning from WaterLevelInsertPage
              },
              child: Text('Insert Water Level Data'),
            ),
          ],
        ),
      ),
    );
  }
}

class WaterLevelIndicator extends StatelessWidget {
  final List<Map<String, dynamic>> waterLevelData;

  const WaterLevelIndicator({Key? key, required this.waterLevelData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var data in waterLevelData)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Area Name: ${data['areaName']}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Water Level: ${data['waterLevel']}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ComplainFiling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'File a Complain',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComplainPage()),
              );
            },
            child: Text('File a Complain'),
          ),
        ],
      ),
    );
  }
}
