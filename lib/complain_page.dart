import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'DatabaseService.dart';
import 'homepage.dart'; // Import your homepage file

class ComplainPage extends StatefulWidget {
  @override
  _ComplainPageState createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  final TextEditingController _reportController = TextEditingController();
  File? _image;

  Future<String> _saveImageToFile(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(imagePath);
    await file.writeAsBytes(imageBytes);
    return imagePath;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final imagePath = await _saveImageToFile(bytes);
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _submitComplaint(BuildContext context) async {
    String report = _reportController.text.trim();
    String? imagePath = _image?.path;

    if (report.isNotEmpty) {
      await DatabaseService().insertComplaint(report, imagePath);
      setState(() {
        _reportController.clear();
        _image = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complaint submitted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      // Navigate back to homepage after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context); // Go back to the previous screen (HomePage)
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a report')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File a Complain'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _reportController,
                decoration: InputDecoration(
                  labelText: 'Report',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Attach Picture'),
              ),
              SizedBox(height: 20),
              if (_image != null) Image.file(_image!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitComplaint(context),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
