import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "";

  Future<void> uploadPdf() async {
    FilePickerResult? picked =
        await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (picked == null) return;

    String path = picked.files.single.path!;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/extract'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        path,
      ),
    );

    var response = await request.send();

    var responseString =
        await response.stream.bytesToString();

    var jsonData = jsonDecode(responseString);

    setState(() {
      result = jsonData["content"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scientific Paper Reader"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: uploadPdf,
              child: const Text("Upload PDF"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}