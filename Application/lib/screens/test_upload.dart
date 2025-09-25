import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart';

class TestUploadPage extends StatefulWidget {
  @override
  _TestUploadPageState createState() => _TestUploadPageState();
}

class _TestUploadPageState extends State<TestUploadPage> {
  File? _selectedFile;
  String? _uploadedUrl;
  bool _loading = false;

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _selectedFile = File(picked.path));
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() => _loading = true);
    final url = await CloudinaryService().uploadFile(_selectedFile!);
    setState(() {
      _loading = false;
      _uploadedUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Cloudinary Upload")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: Text("Pick Image"),
            ),
            if (_selectedFile != null) Image.file(_selectedFile!, height: 150),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: _loading ? CircularProgressIndicator() : Text("Upload to Cloudinary"),
            ),
            if (_uploadedUrl != null) ...[
              SizedBox(height: 20),
              Text("Uploaded URL:"),
              SelectableText(_uploadedUrl!),
              Image.network(_uploadedUrl!, height: 150),
            ],
          ],
        ),
      ),
    );
  }
}
