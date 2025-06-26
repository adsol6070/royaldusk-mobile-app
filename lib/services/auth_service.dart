import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:royaldusk_mobile_app/models/user.dart';

class AuthService {
  static final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static User? _currentUser;

  static bool get isSignedIn => _currentUser != null;
  static User? get currentUser => _currentUser;

  // Initialize auth state listener
  static void initialize() {
    _firebaseAuth.authStateChanges().listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser != null) {
        _currentUser = _convertFirebaseUserToUser(firebaseUser);
      } else {
        _currentUser = null;
      }
    });
  }

  // Google Sign In
  static Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google user credential
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        _currentUser = _convertFirebaseUserToUser(userCredential.user!);
        return _currentUser;
      }

      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  // Apple Sign In
  static Future<User?> signInWithApple() async {
    try {
      // Generate a random nonce
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple
      final oauthCredential =
          firebase_auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        // Update display name if provided by Apple (first time sign in)
        if (appleCredential.givenName != null ||
            appleCredential.familyName != null) {
          String displayName = '';
          if (appleCredential.givenName != null) {
            displayName += appleCredential.givenName!;
          }
          if (appleCredential.familyName != null) {
            if (displayName.isNotEmpty) displayName += ' ';
            displayName += appleCredential.familyName!;
          }

          await userCredential.user!.updateDisplayName(displayName);
        }

        _currentUser = _convertFirebaseUserToUser(userCredential.user!);
        return _currentUser;
      }

      return null;
    } catch (e) {
      print('Error signing in with Apple: $e');
      rethrow;
    }
  }

  // Email/Password Sign In (you can implement this later)
  static Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        _currentUser = _convertFirebaseUserToUser(userCredential.user!);
        return _currentUser;
      }

      return null;
    } catch (e) {
      print('Error signing in with email: $e');
      rethrow;
    }
  }

  // Sign Out
  static Future<void> signOut() async {
    try {
      // Sign out from Google if signed in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Sign out from Firebase
      await _firebaseAuth.signOut();

      _currentUser = null;
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Mock sign in (for testing)
  static void signIn(User user) {
    _currentUser = user;
  }

  // Helper methods
  static User _convertFirebaseUserToUser(firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      phone: firebaseUser.phoneNumber,
      avatar: firebaseUser.photoURL,
      joinedDate: firebaseUser.metadata.creationTime ?? DateTime.now(),
      isVerified: firebaseUser.emailVerified,
    );
  }

  // Generate a cryptographically secure random nonce
  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  // Returns the sha256 hash of [input] in hex notation
  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Mock user for testing
  static User get mockUser => User(
        id: '1',
        name: 'John Explorer',
        email: 'john.explorer@email.com',
        phone: '+971 50 123 4567',
        joinedDate: DateTime(2023, 1, 15),
        isVerified: true,
      );
}
