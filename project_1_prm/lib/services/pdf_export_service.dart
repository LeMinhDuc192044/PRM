import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfExportService {
  Future<File> exportDocument({
    required String title,
    required String category,
    String? body,
    String? sourcePath,
  }) async {
    if (sourcePath != null && sourcePath.toLowerCase().endsWith('.pdf')) {
      final sourceFile = File(sourcePath);
      if (await sourceFile.exists()) {
        final targetFile = await _createTargetFile(title);
        await sourceFile.copy(targetFile.path);
        return targetFile;
      }
    }

    final document = PdfDocument();
    final page = document.pages.add();
    final font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    final titleFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      20,
      style: PdfFontStyle.bold,
    );

    page.graphics.drawString(
      title,
      titleFont,
      bounds: const Rect.fromLTWH(0, 0, 500, 30),
    );
    page.graphics.drawString(
      'Category: $category',
      font,
      bounds: const Rect.fromLTWH(0, 40, 500, 20),
    );
    page.graphics.drawString(
      body?.trim().isNotEmpty == true ? body!.trim() : 'No content available',
      font,
      bounds: const Rect.fromLTWH(0, 75, 500, 700),
      format: PdfStringFormat(lineSpacing: 6),
    );

    final bytes = await document.save();
    document.dispose();

    final targetFile = await _createTargetFile(title);
    await targetFile.writeAsBytes(bytes, flush: true);
    return targetFile;
  }

  Future<File> _createTargetFile(String title) async {
    final directory = await getApplicationDocumentsDirectory();
    final exportsDirectory = Directory(
      '${directory.path}${Platform.pathSeparator}exports',
    );
    if (!await exportsDirectory.exists()) {
      await exportsDirectory.create(recursive: true);
    }

    final safeName = title
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();

    return File(
      '${exportsDirectory.path}${Platform.pathSeparator}${safeName.isEmpty ? 'document' : safeName}_export.pdf',
    );
  }
}
