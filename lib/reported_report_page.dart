import 'package:flutter/material.dart';
import 'DatabaseService.dart';
import 'dart:io';

class ReportedReportPage extends StatefulWidget {
  @override
  _ReportedReportPageState createState() => _ReportedReportPageState();
}

class _ReportedReportPageState extends State<ReportedReportPage> {
  late Future<List<Map<String, dynamic>>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _complaintsFuture = DatabaseService().fetchComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reported Complaints'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _complaintsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No complaints found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final complaint = snapshot.data![index];
                return ListTile(
                  title: Text(complaint['report']),
                  subtitle: complaint['imagePath'] != null
                      ? Image.file(File(complaint['imagePath']))
                      : Text('No image'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
