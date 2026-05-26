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
    const seed = Color(0xFF163B6C);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scientific Paper Reader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF14314F),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(height: 1.5),
          bodyLarge: TextStyle(height: 1.5),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class NoteItem {
  final String category;
  final String file;

  const NoteItem({
    required this.category,
    required this.file,
  });

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      category: (json['category'] ?? '').toString(),
      file: (json['file'] ?? '').toString(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String backendBaseUrl = 'http://127.0.0.1:8000';
  static const List<String> categories = <String>[
    'AI',
    'ComputerScience',
    'DataScience',
  ];

  final TextEditingController _searchController = TextEditingController();

  List<NoteItem> notes = <NoteItem>[];
  String selectedCategory = 'AI';
  String searchQuery = '';
  bool isLoading = true;
  bool isUploading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchNotes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('$backendBaseUrl/notes'));

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final dynamic data = jsonDecode(response.body);
      final List<dynamic> rawList = data is List ? data : <dynamic>[];

      setState(() {
        notes = rawList
            .whereType<Map<String, dynamic>>()
            .map(NoteItem.fromJson)
            .toList();
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Không tải được danh sách ghi chú. ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> uploadPdf() async {
    if (isUploading) return;

    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['pdf'],
    );

    if (picked == null || picked.files.single.path == null) return;

    setState(() {
      isUploading = true;
      errorMessage = null;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$backendBaseUrl/extract'),
      );

      request.fields['category'] = selectedCategory;
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          picked.files.single.path!,
        ),
      );

      final response = await request.send();

      if (response.statusCode >= 400) {
        throw Exception('HTTP ${response.statusCode}');
      }

      await fetchNotes();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xử lý PDF vào danh mục ${_displayCategory(selectedCategory)}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Upload thất bại. ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  List<NoteItem> get filteredNotes {
    if (searchQuery.trim().isEmpty) return notes;
    final query = searchQuery.toLowerCase();
    return notes.where((note) {
      return note.file.toLowerCase().contains(query) ||
          note.category.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleNotes = filteredNotes;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFF4F7FB),
              Color(0xFFEAF1FF),
              Color(0xFFF9FAFC),
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: fetchNotes,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: _buildHeader(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildActionPanel(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _buildStatsRow(visibleNotes.length),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: _buildSearchField(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildCategoryChips(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: _buildSectionTitle(
                      'Ghi chú đã xử lý',
                      '${visibleNotes.length} kết quả',
                    ),
                  ),
                ),
                if (isLoading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (errorMessage != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildErrorState(),
                  )
                else if (visibleNotes.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList.separated(
                      itemCount: visibleNotes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final note = visibleNotes[index];
                        return _NoteCard(
                          note: note,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReaderPage(
                                  category: note.category,
                                  file: note.file,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF163B6C),
            Color(0xFF275EAA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x260D1F3D),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Scientific Paper Reader',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Tải PDF, tra cứu nhanh và đọc lại nội dung đã trích xuất.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE4EBF4)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0D17324D),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Tải PDF vào danh mục',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7F9FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
            items: categories
                .map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(_displayCategory(category)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                selectedCategory = value;
              });
            },
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isUploading ? null : uploadPdf,
              icon: isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file_rounded),
              label: Text(isUploading ? 'Đang xử lý...' : 'Upload PDF'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int visibleCount) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _StatCard(
            label: 'Tổng ghi chú',
            value: notes.length.toString(),
            icon: Icons.library_books_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Đang hiển thị',
            value: visibleCount.toString(),
            icon: Icons.manage_search_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Tìm theo tên file hoặc danh mục...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: searchQuery.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    searchQuery = '';
                  });
                },
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E9F3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF275EAA), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final bool selected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_displayCategory(category)),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  selectedCategory = category;
                });
              },
              labelStyle: TextStyle(
                color: selected ? Colors.white : const Color(0xFF14314F),
                fontWeight: FontWeight.w600,
              ),
              selectedColor: const Color(0xFF275EAA),
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFD8E2EF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF6C7B8D),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: fetchNotes,
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Làm mới',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.find_in_page_rounded,
                size: 42,
                color: Color(0xFF275EAA),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Không có kết quả phù hợp',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Hãy thử đổi từ khóa tìm kiếm hoặc chọn danh mục khác.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6C7B8D),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Color(0xFFB54747),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage ?? 'Có lỗi xảy ra.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF8B2E2E),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: fetchNotes,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4EBF4)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF275EAA)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF6C7B8D),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final NoteItem note;
  final VoidCallback onTap;

  const _NoteCard({
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE4EBF4)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0A17324D),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: Color(0xFF275EAA),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    note.file,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      _Tag(text: _displayCategory(note.category)),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Color(0xFF6C7B8D),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF4A5B72),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _displayCategory(String category) {
  if (category == 'ComputerScience') return 'Computer Science';
  return category;
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
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  static const String backendBaseUrl = 'http://127.0.0.1:8000';

  final TextEditingController _readerSearchController =
      TextEditingController();

  String content = '';
  String readerQuery = '';
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    readNote();
  }

  @override
  void dispose() {
    _readerSearchController.dispose();
    super.dispose();
  }

  Future<void> readNote() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$backendBaseUrl/read/${widget.category}/${widget.file}'),
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final dynamic data = jsonDecode(response.body);
      setState(() {
        content = (data['content'] ?? '').toString();
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Không đọc được nội dung. ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String highlightedContent = _filterContent(content, readerQuery);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.file,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: readNote,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Làm mới nội dung',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFF4F7FB),
              Color(0xFFEAF1FF),
              Color(0xFFF9FAFC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE4EBF4)),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x0D17324D),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _Tag(text: _displayCategory(widget.category)),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.description_rounded,
                            size: 18,
                            color: Color(0xFF6C7B8D),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _readerSearchController,
                        onChanged: (value) {
                          setState(() {
                            readerQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Tìm trong nội dung...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: readerQuery.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _readerSearchController.clear();
                                    setState(() {
                                      readerQuery = '';
                                    });
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                          filled: true,
                          fillColor: const Color(0xFFF7F9FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE4EBF4)),
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : errorMessage != null
                            ? _ReaderErrorState(
                                message: errorMessage!,
                                onRetry: readNote,
                              )
                            : highlightedContent.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Không có nội dung để hiển thị.',
                                      style: TextStyle(
                                        color: Color(0xFF6C7B8D),
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Text(
                                      highlightedContent,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.6,
                                        color: Color(0xFF20324A),
                                      ),
                                    ),
                                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _filterContent(String source, String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty || source.isEmpty) return source;

    final lowerSource = source.toLowerCase();
    final lowerQuery = trimmed.toLowerCase();
    if (!lowerSource.contains(lowerQuery)) {
      return 'Không tìm thấy từ khóa "$trimmed".\n\n$source';
    }
    return source;
  }
}

class _ReaderErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ReaderErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: Color(0xFFB54747),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF8B2E2E),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
