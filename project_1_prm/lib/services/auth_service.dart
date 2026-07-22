import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_1_prm/services/firebase_bootstrap_service.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _googleSignInInitialized = false;

  FirebaseAuth get _auth {
    if (!FirebaseBootstrapService.isInitialized) {
      throw StateError('Firebase is not configured yet.');
    }
    return _firebaseAuth ?? FirebaseAuth.instance;
  }

  bool get isAvailable => FirebaseBootstrapService.isInitialized;

  User? get currentUser => isAvailable ? _auth.currentUser : null;

  Stream<User?> get authStateChanges {
    if (!isAvailable) return const Stream<User?>.empty();
    return _auth.authStateChanges();
  }

  Future<UserCredential> signInWithGoogle() async {
    if (!isAvailable) {
      throw StateError(
        'Firebase is not configured. Add Firebase options/config files first.',
      );
    }

    if (!_googleSignInInitialized) {
      await _googleSignIn.initialize();
      _googleSignInInitialized = true;
    }

    if (!_googleSignIn.supportsAuthenticate()) {
      throw UnsupportedError(
        'Google Sign-In is not supported on this platform.',
      );
    }

    final googleAccount = await _googleSignIn.authenticate();
    final googleAuth = googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    if (!isAvailable) return;
    await Future.wait(<Future<void>>[_auth.signOut(), _googleSignIn.signOut()]);
  }
}
