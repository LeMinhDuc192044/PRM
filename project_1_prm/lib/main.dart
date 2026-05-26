import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const ScientificPaperReaderApp());
}

class AppColors {
  static const Color ink = Color(0xFF102A43);
  static const Color text = Color(0xFF334E68);
  static const Color muted = Color(0xFF829AB1);
  static const Color sky = Color(0xFF2F80ED);
  static const Color blue = Color(0xFF1E4E8C);
  static const Color cyan = Color(0xFF18A0AA);
  static const Color sand = Color(0xFFF7F1E8);
  static const Color paper = Color(0xFFF4F8FC);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFD9E2EC);
  static const LinearGradient heroGradient = LinearGradient(
    colors: <Color>[Color(0xFF102A43), Color(0xFF1E4E8C), Color(0xFF2F80ED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class ScientificPaperReaderApp extends StatelessWidget {
  const ScientificPaperReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scientific Paper Reader',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.blue,
          onPrimary: Colors.white,
          secondary: AppColors.cyan,
          onSecondary: Colors.white,
          error: Color(0xFFB54747),
          onError: Colors.white,
          surface: AppColors.surface,
          onSurface: AppColors.ink,
        ),
        scaffoldBackgroundColor: AppColors.paper,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.ink,
          elevation: 0,
          centerTitle: false,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.text),
          bodySmall: TextStyle(color: AppColors.muted),
        ),
      ),
      home: const MainReaderScreen(),
    );
  }
}

class DocumentItem {
  final String category;
  final String file;

  const DocumentItem({
    required this.category,
    required this.file,
  });

  factory DocumentItem.fromJson(Map<String, dynamic> json) {
    return DocumentItem(
      category: (json['category'] ?? '').toString(),
      file: (json['file'] ?? '').toString(),
    );
  }
}

class MainReaderScreen extends StatefulWidget {
  const MainReaderScreen({super.key});

  @override
  State<MainReaderScreen> createState() => _MainReaderScreenState();
}

class _MainReaderScreenState extends State<MainReaderScreen> {
  static const String backendBaseUrl = 'http://127.0.0.1:8000';
  static const List<String> categories = <String>[
    'AI',
    'ComputerScience',
    'DataScience',
  ];

  final TextEditingController _fileSearchController = TextEditingController();
  final TextEditingController _contentSearchController = TextEditingController();
  final PdfViewerController _pdfController = PdfViewerController();

  List<DocumentItem> _documents = <DocumentItem>[];
  String _fileSearchQuery = '';
  String _contentSearchQuery = '';
  String? _selectedCategory = 'AI';
  String? _selectedFile;
  String? _selectedContent;
  String? _selectedPath;
  String? _selectedKind;
  bool _isLoading = true;
  String? _errorMessage;
  double _sidebarWidth = 340;

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  @override
  void dispose() {
    _fileSearchController.dispose();
    _contentSearchController.dispose();
    _pdfController.dispose();
    super.dispose();
  }

  Future<void> _fetchDocuments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('$backendBaseUrl/notes'));
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final dynamic data = jsonDecode(response.body);
      final List<dynamic> rawList = data is List ? data : <dynamic>[];

      setState(() {
        _documents = rawList
            .whereType<Map<String, dynamic>>()
            .map(DocumentItem.fromJson)
            .toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load documents. ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadPdf() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['pdf'],
      allowMultiple: false,
      withData: false,
    );

    if (picked == null || picked.files.single.path == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$backendBaseUrl/extract'),
    );

    request.fields['category'] = _selectedCategory ?? categories.first;
    request.files.add(
      await http.MultipartFile.fromPath('file', picked.files.single.path!),
    );

    final response = await request.send();
    if (response.statusCode >= 400) {
      throw Exception('HTTP ${response.statusCode}');
    }

    await _fetchDocuments();
  }

  List<DocumentItem> get _filteredDocuments {
    final query = _fileSearchQuery.trim().toLowerCase();
    if (query.isEmpty) return _documents;
    return _documents.where((document) {
      return document.file.toLowerCase().contains(query) ||
          document.category.toLowerCase().contains(query);
    }).toList();
  }

  Map<String, List<DocumentItem>> get _groupedDocuments {
    final Map<String, List<DocumentItem>> grouped = <String, List<DocumentItem>>{
      for (final category in categories) category: <DocumentItem>[],
    };

    for (final document in _filteredDocuments) {
      grouped.putIfAbsent(document.category, () => <DocumentItem>[]).add(document);
    }

    return grouped;
  }

  Future<void> _openDocument(DocumentItem document) async {
    final filePath = _localDocumentPath(document);
    final file = File(filePath);
    final exists = await file.exists();

    String? content;
    String kind = _isMarkdown(document.file) ? 'markdown' : 'pdf';

    if (exists && _isMarkdown(document.file)) {
      content = await file.readAsString();
    } else if (exists && !_isMarkdown(document.file)) {
      kind = 'pdf';
    } else if (exists) {
      content = await file.readAsString();
      kind = 'markdown';
    } else {
      kind = 'missing';
    }

    setState(() {
      _selectedFile = document.file;
      _selectedCategory = document.category;
      _selectedPath = filePath;
      _selectedKind = kind;
      _selectedContent = content;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedFile = null;
      _selectedContent = null;
      _selectedPath = null;
      _selectedKind = null;
    });
  }

  int get _filteredCount {
    return _groupedDocuments.values.fold<int>(0, (sum, list) => sum + list.length);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scientific Paper Reader',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                color: Color(0x66000000),
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.heroGradient,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _fetchDocuments,
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: _sidebarWidth,
              child: _Sidebar(
                fileSearchController: _fileSearchController,
                fileSearchQuery: _fileSearchQuery,
                onFileSearchChanged: (value) {
                  setState(() {
                    _fileSearchQuery = value;
                  });
                },
                onClearFileSearch: () {
                  setState(() {
                    _fileSearchQuery = '';
                    _fileSearchController.clear();
                  });
                },
                onUpload: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await _uploadPdf();
                    if (!mounted) return;
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('PDF uploaded successfully'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Upload failed: $e'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                categories: categories,
                groupedDocuments: _groupedDocuments,
                selectedCategory: _selectedCategory,
                selectedFile: _selectedFile,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                onFileSelected: _openDocument,
                searchCount: _filteredCount,
                searchQuery: _fileSearchQuery,
              ),
            ),
            _SplitHandle(
              onDrag: (delta) {
                setState(() {
                  _sidebarWidth = (_sidebarWidth + delta).clamp(300.0, math.max(420.0, screenWidth * 0.42));
                });
              },
            ),
            Expanded(
              child: _ReaderCanvas(
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                selectedFile: _selectedFile,
                selectedPath: _selectedPath,
                selectedKind: _selectedKind,
                selectedContent: _selectedContent,
                contentSearchController: _contentSearchController,
                contentSearchQuery: _contentSearchQuery,
                onContentSearchChanged: (value) {
                  setState(() {
                    _contentSearchQuery = value;
                  });
                  if (_selectedKind == 'pdf') {
                    _pdfController.searchText(value);
                  }
                },
                onClearContentSearch: () {
                  setState(() {
                    _contentSearchQuery = '';
                    _contentSearchController.clear();
                  });
                  if (_selectedKind == 'pdf') {
                    _pdfController.clearSelection();
                  }
                },
                pdfController: _pdfController,
                onClearSelection: _clearSelection,
                onRetry: _fetchDocuments,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final TextEditingController fileSearchController;
  final String fileSearchQuery;
  final ValueChanged<String> onFileSearchChanged;
  final VoidCallback onClearFileSearch;
  final VoidCallback onUpload;
  final List<String> categories;
  final Map<String, List<DocumentItem>> groupedDocuments;
  final String? selectedCategory;
  final String? selectedFile;
  final ValueChanged<String> onCategorySelected;
  final Future<void> Function(DocumentItem) onFileSelected;
  final int searchCount;
  final String searchQuery;

  const _Sidebar({
    required this.fileSearchController,
    required this.fileSearchQuery,
    required this.onFileSearchChanged,
    required this.onClearFileSearch,
    required this.onUpload,
    required this.categories,
    required this.groupedDocuments,
    required this.selectedCategory,
    required this.selectedFile,
    required this.onCategorySelected,
    required this.onFileSelected,
    required this.searchCount,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSearch = searchQuery.trim().isNotEmpty;

    return Container(
      color: AppColors.surface,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
            ),
            child: Row(
              children: const <Widget>[
                Icon(Icons.menu_book_rounded, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Documents & Topics',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: fileSearchController,
                  onChanged: onFileSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search file name or topic...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: const Color(0xFFF1F7FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (hasSearch)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB8D8FF)),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.filter_alt_rounded, size: 18, color: AppColors.sky),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filtering by "$searchQuery"',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: onClearFileSearch,
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),
                if (hasSearch) const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: onUpload,
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: const Text('Upload PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: categories.map((category) {
                final items = groupedDocuments[category] ?? <DocumentItem>[];
                final isExpanded = hasSearch ? items.isNotEmpty : selectedCategory == category;

                if (hasSearch && items.isEmpty) {
                  return const SizedBox.shrink();
                }

                return ExpansionTile(
                  initiallyExpanded: isExpanded,
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: const Color(0xFFF0F7FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  title: Text(
                    '$category (${items.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  leading: const Icon(Icons.folder_rounded, color: AppColors.cyan),
                  onExpansionChanged: (expanded) {
                    if (expanded) onCategorySelected(category);
                  },
                  children: items.isEmpty
                      ? <Widget>[
                          const ListTile(
                            dense: true,
                            title: Text(
                              'No documents',
                              style: TextStyle(color: Color(0xFF6C7B8D)),
                            ),
                          ),
                        ]
                      : items.map((document) {
                          final bool selected = document.file == selectedFile;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: selected ? const Color(0xFFDFF1FF) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected ? const Color(0xFF99C9FF) : const Color(0xFFE3EAF3),
                                ),
                              ),
                              child: ListTile(
                                selected: selected,
                                selectedTileColor: const Color(0xFFDFF1FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                leading: Icon(
                                  _isMarkdown(document.file)
                                      ? Icons.description_rounded
                                      : Icons.picture_as_pdf_rounded,
                                  color: selected ? AppColors.ink : AppColors.sky,
                                ),
                                title: _highlightedFileTitle(
                                  document.file,
                                  searchQuery,
                                  selected ? AppColors.ink : const Color(0xFF24364B),
                                  selected ? FontWeight.w700 : FontWeight.w500,
                                ),
                                onTap: () => onFileSelected(document),
                              ),
                            ),
                          );
                        }).toList(),
                );
              }).whereType<Widget>().toList(),
            ),
          ),
          if (hasSearch)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF7FAFD),
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: Text(
                searchCount == 0
                    ? 'No matching documents found'
                    : 'Found $searchCount matching documents',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReaderCanvas extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final String? selectedFile;
  final String? selectedPath;
  final String? selectedKind;
  final String? selectedContent;
  final TextEditingController contentSearchController;
  final String contentSearchQuery;
  final ValueChanged<String> onContentSearchChanged;
  final VoidCallback onClearContentSearch;
  final PdfViewerController pdfController;
  final VoidCallback onClearSelection;
  final VoidCallback onRetry;

  const _ReaderCanvas({
    required this.isLoading,
    required this.errorMessage,
    required this.selectedFile,
    required this.selectedPath,
    required this.selectedKind,
    required this.selectedContent,
    required this.contentSearchController,
    required this.contentSearchQuery,
    required this.onContentSearchChanged,
    required this.onClearContentSearch,
    required this.pdfController,
    required this.onClearSelection,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.cloud_off_rounded, size: 48, color: Color(0xFFB54747)),
              const SizedBox(height: 12),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (selectedFile == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.description_outlined, size: 88, color: Colors.blueGrey.shade100),
            const SizedBox(height: 16),
            const Text(
              'Select a document in the left sidebar to start reading',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.muted),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x120D1F3D),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    selectedFile!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 290,
                  child: TextField(
                    controller: contentSearchController,
                    onChanged: onContentSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search in content...',
                      prefixIcon: const Icon(Icons.find_in_page_rounded),
                      suffixIcon: contentSearchQuery.isEmpty
                          ? null
                          : IconButton(
                              onPressed: onClearContentSearch,
                              icon: const Icon(Icons.close_rounded),
                            ),
                      filled: true,
                      fillColor: const Color(0xFFF8FBFF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onClearSelection,
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Close document',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (contentSearchQuery.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB8D8FF)),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.highlight_rounded, size: 18, color: AppColors.sky),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Highlighting matches for "$contentSearchQuery"',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onClearContentSearch,
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildViewer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewer() {
    if (selectedKind == 'pdf' && selectedPath != null && File(selectedPath!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SfPdfViewer.file(
          File(selectedPath!),
          controller: pdfController,
          canShowScrollHead: true,
          canShowScrollStatus: true,
        ),
      );
    }

    if (selectedContent != null) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(16),
        child: Markdown(
          data: selectedContent!,
          selectable: true,
        ),
      );
    }

    return Center(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.description_outlined, size: 88, color: Colors.blueGrey.shade100),
          const SizedBox(height: 16),
          const Text(
            'This file could not be found in the workspace.',
            style: TextStyle(fontSize: 16, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

Widget _highlightedFileTitle(
  String fileName,
  String query,
  Color color,
  FontWeight weight,
) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    return Text(
      fileName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontWeight: weight),
    );
  }

  final lower = fileName.toLowerCase();
  final q = trimmed.toLowerCase();
  final index = lower.indexOf(q);
  if (index < 0) {
    return Text(
      fileName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontWeight: weight),
    );
  }

  return RichText(
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    text: TextSpan(
      style: TextStyle(color: color, fontWeight: weight, fontSize: 14),
      children: <InlineSpan>[
        TextSpan(text: fileName.substring(0, index)),
        TextSpan(
          text: fileName.substring(index, index + trimmed.length),
          style: const TextStyle(
            backgroundColor: Color(0xFFBDE0FE),
            color: AppColors.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextSpan(text: fileName.substring(index + trimmed.length)),
      ],
    ),
  );
}

bool _isMarkdown(String fileName) => fileName.toLowerCase().endsWith('.md');

String _localDocumentPath(DocumentItem document) {
  return '${Directory.current.path}${Platform.pathSeparator}ObsidianVault${Platform.pathSeparator}${document.category}${Platform.pathSeparator}${document.file}';
}

class _SplitHandle extends StatelessWidget {
  final ValueChanged<double> onDrag;

  const _SplitHandle({required this.onDrag});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) => onDrag(details.delta.dx),
        child: Container(
          width: 10,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 2,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
