import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your database helper class

class WaterLevelInsertPage extends StatefulWidget {
  @override
  _WaterLevelInsertPageState createState() => _WaterLevelInsertPageState();
}

class _WaterLevelInsertPageState extends State<WaterLevelInsertPage> {
  final TextEditingController _areaNameController = TextEditingController();
  final TextEditingController _waterLevelController = TextEditingController();
  final TextEditingController _rateOfChangeController = TextEditingController();

  void _insertData() async {
    String areaName = _areaNameController.text;
    int waterLevel = int.tryParse(_waterLevelController.text) ?? 0;
    int rateOfChange = int.tryParse(_rateOfChangeController.text) ?? 0;

    Map<String, dynamic> row = {
      'areaName': areaName,
      'waterLevel': waterLevel,
      'rateOfChange': rateOfChange,
    };

    // Insert data into the database
    await DatabaseHelper().insertWaterLevel(row);
    
    // After inserting data, pop the page to go back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Water Level Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _areaNameController,
              decoration: InputDecoration(labelText: 'Area Name'),
            ),
            TextField(
              controller: _waterLevelController,
              decoration: InputDecoration(labelText: 'Water Level'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _rateOfChangeController,
              decoration: InputDecoration(labelText: 'Rate of Change'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _insertData,
              child: Text('Insert Data'),
            ),
          ],
        ),
      ),
    );
  }
}
