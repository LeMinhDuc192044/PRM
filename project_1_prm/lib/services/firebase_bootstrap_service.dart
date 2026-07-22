import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrapService {
  const FirebaseBootstrapService._();

  static bool isInitialized = false;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      isInitialized = true;
    } catch (error, stackTrace) {
      isInitialized = false;
      debugPrint('Firebase initialization skipped: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
