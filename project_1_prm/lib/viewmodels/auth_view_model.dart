import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:project_1_prm/services/app_monitoring_service.dart';
import 'package:project_1_prm/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({AuthService? authService})
    : _authService = authService ?? AuthService() {
    _user = _authService.currentUser;
    _subscription = _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final AuthService _authService;
  StreamSubscription<User?>? _subscription;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSignedIn => _user != null;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithGoogle() async {
    await _runAuthAction(() async {
      await _authService.signInWithGoogle();
      await AppMonitoringService.logLogin(method: 'google');
    });
  }

  Future<void> signOut() async {
    await _runAuthAction(() async {
      await _authService.signOut();
      await AppMonitoringService.logSignOut();
    });
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
    } catch (error, stackTrace) {
      await AppMonitoringService.recordError(error, stackTrace);
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
