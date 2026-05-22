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

  List notes = [];

  String selectedCategory = "AI";

  Future<void> fetchNotes() async {

    var response = await http.get(
      Uri.parse('http://127.0.0.1:8000/notes'),
    );

    var data = jsonDecode(response.body);

    setState(() {
      notes = data;
    });
  }

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

    request.fields['category'] = selectedCategory;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        path,
      ),
    );

    await request.send();

    await fetchNotes();
  }

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Scientific Paper Reader",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,

              items: const [

                DropdownMenuItem(
                  value: "AI",
                  child: Text("AI"),
                ),

                DropdownMenuItem(
                  value: "ComputerScience",
                  child: Text(
                    "Computer Science",
                  ),
                ),

                DropdownMenuItem(
                  value: "DataScience",
                  child: Text(
                    "Data Science",
                  ),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: uploadPdf,
              child: const Text(
                "Upload PDF",
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(

                itemCount: notes.length,

                itemBuilder: (context, index) {

                  var note = notes[index];

                  return GestureDetector(

                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => ReaderPage(
                            category: note["category"],
                            file: note["file"],
                          ),
                        ),
                      );
                    },

                    child: Card(

                      child: Padding(
                        padding:
                            const EdgeInsets.all(12),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              note["file"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              note["category"],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReaderPage extends StatefulWidget {

  final String category;
  final String file;

  const ReaderPage({
    super.key,
    required this.category,
    required this.file,
  });

  @override
  State<ReaderPage> createState() =>
      _ReaderPageState();
}

class _ReaderPageState
    extends State<ReaderPage> {

  String content = "";

  Future<void> readNote() async {

    var response = await http.get(

      Uri.parse(
        'http://127.0.0.1:8000/read/${widget.category}/${widget.file}',
      ),
    );

    var data = jsonDecode(response.body);

    setState(() {
      content = data["content"];
    });
  }

  @override
  void initState() {
    super.initState();
    readNote();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.file),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}