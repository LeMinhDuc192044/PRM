import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_1_prm/services/firebase_bootstrap_service.dart';

class StorageService {
  StorageService({FirebaseStorage? storage}) : _storage = storage;

  final FirebaseStorage? _storage;

  bool get isAvailable => FirebaseBootstrapService.isInitialized;

  FirebaseStorage get _instance {
    if (!isAvailable) {
      throw StateError('Firebase Storage is not configured yet.');
    }
    return _storage ?? FirebaseStorage.instance;
  }

  Future<String?> uploadExportedPdf({
    required File file,
    required String fileName,
    required String category,
  }) async {
    if (!isAvailable) return null;

    final reference = _instance
        .ref()
        .child('exports')
        .child(category)
        .child(fileName);

    await reference.putFile(file);
    return reference.getDownloadURL();
  }
}
