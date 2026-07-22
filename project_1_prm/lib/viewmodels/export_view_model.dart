import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:project_1_prm/services/pdf_export_service.dart';
import 'package:project_1_prm/services/storage_service.dart';

class ExportResult {
  const ExportResult({required this.file, this.downloadUrl});

  final File file;
  final String? downloadUrl;
}

class ExportViewModel extends ChangeNotifier {
  ExportViewModel({
    PdfExportService? pdfExportService,
    StorageService? storageService,
  }) : _pdfExportService = pdfExportService ?? PdfExportService(),
       _storageService = storageService ?? StorageService();

  final PdfExportService _pdfExportService;
  final StorageService _storageService;

  bool _isExporting = false;
  String? _errorMessage;
  ExportResult? _lastResult;

  bool get isExporting => _isExporting;
  String? get errorMessage => _errorMessage;
  ExportResult? get lastResult => _lastResult;

  Future<void> exportDocument({
    required String title,
    required String category,
    String? body,
    String? sourcePath,
  }) async {
    _isExporting = true;
    _errorMessage = null;
    _lastResult = null;
    notifyListeners();

    try {
      final file = await _pdfExportService.exportDocument(
        title: title,
        category: category,
        body: body,
        sourcePath: sourcePath,
      );

      final downloadUrl = await _storageService.uploadExportedPdf(
        file: file,
        fileName: file.uri.pathSegments.last,
        category: category,
      );

      _lastResult = ExportResult(file: file, downloadUrl: downloadUrl);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _lastResult = null;
    notifyListeners();
  }
}
