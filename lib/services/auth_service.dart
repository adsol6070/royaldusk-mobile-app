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
  static String? _verificationId;

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
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      if (appleCredential.identityToken == null) {
        return null;
      }

      final oauthCredential = firebase_auth.OAuthProvider("apple.com")
          .credential(
              idToken: appleCredential.identityToken,
              rawNonce: rawNonce,
              accessToken: appleCredential.authorizationCode);

      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        if (appleCredential.givenName != null ||
            appleCredential.familyName != null) {
          String displayName = '';
          if (appleCredential.givenName != null)
            displayName += appleCredential.givenName!;
          if (appleCredential.familyName != null) {
            if (displayName.isNotEmpty) displayName += ' ';
            displayName += appleCredential.familyName!;
          }

          await userCredential.user!.updateDisplayName(displayName);
        }

        _currentUser = _convertFirebaseUserToUser(userCredential.user!);
        return _currentUser;
      } else {
        return null;
      }
    } catch (e, stack) {
      print('[EXCEPTION] Error signing in with Apple: $e');
      print('[STACKTRACE]\n$stack');
      rethrow;
    }
  }

  static Future<bool> sendOTPToPhone(
    String phoneNumber, {
    required Function(String) onCodeSent,
    required Function(String) onError,
    Function(firebase_auth.UserCredential)? onAutoVerification,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
          // Auto-verification completed (Android only)
          try {
            final userCredential =
                await _firebaseAuth.signInWithCredential(credential);
            if (onAutoVerification != null) {
              onAutoVerification(userCredential);
            }
            if (userCredential.user != null) {
              _currentUser = _convertFirebaseUserToUser(userCredential.user!);
            }
          } catch (e) {
            onError('Auto-verification failed: ${e.toString()}');
          }
        },
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          String errorMessage = 'Verification failed';

          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = 'The phone number entered is invalid.';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many requests. Please try again later.';
              break;
            case 'quota-exceeded':
              errorMessage = 'SMS quota exceeded. Please try again later.';
              break;
            default:
              errorMessage = e.message ?? 'Verification failed';
          }

          onError(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
      return true;
    } catch (e) {
      onError('Failed to send OTP: ${e.toString()}');
      return false;
    }
  }

  // Phone Authentication - Verify OTP
  static Future<User?> verifyOTPAndSignIn(
    String otp, {
    String? verificationId,
  }) async {
    try {
      final String verifyId = verificationId ?? _verificationId ?? '';

      if (verifyId.isEmpty) {
        throw Exception('Verification ID not found. Please request OTP again.');
      }

      // Create a PhoneAuthCredential with the code
      final firebase_auth.PhoneAuthCredential credential =
          firebase_auth.PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: otp,
      );

      // Sign the user in (or link) with the credential
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        _currentUser = _convertFirebaseUserToUser(userCredential.user!);
        return _currentUser;
      }

      return null;
    } catch (e) {
      print('Error verifying OTP: $e');

      // Provide more specific error messages
      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-verification-code':
            throw Exception(
                'Invalid verification code. Please check and try again.');
          case 'session-expired':
            throw Exception(
                'Verification code has expired. Please request a new one.');
          default:
            throw Exception(e.message ?? 'Verification failed');
        }
      }

      rethrow;
    }
  }

  // Resend OTP
  static Future<bool> resendOTP(
    String phoneNumber, {
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    // Clear previous verification ID
    _verificationId = null;

    // Send new OTP
    return await sendOTPToPhone(
      phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
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

  // ==================== ACCOUNT DELETION ====================

  /// Permanently delete user account and all associated data
  static Future<void> deleteAccount() async {
    try {
      final firebase_auth.User? firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser == null) {
        throw Exception('No authenticated user found');
      }
      await _deleteUserData(firebaseUser.uid);
      try {
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.signOut();
        }
      } catch (e) {
        // Continue with deletion even if Google sign out fails
      }

      await firebaseUser.delete();

      // Step 4: Clear local state
      _currentUser = null;
      _verificationId = null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print(
          '[ERROR] Firebase Auth error during account deletion: ${e.code} - ${e.message}');

      switch (e.code) {
        case 'requires-recent-login':
          throw Exception(
              'For security reasons, you need to sign in again before deleting your account. Please sign out and sign back in, then try again.');
        case 'user-not-found':
          throw Exception(
              'Account not found. It may have already been deleted.');
        case 'network-request-failed':
          throw Exception(
              'Network error. Please check your connection and try again.');
        default:
          throw Exception(
              'Failed to delete account: ${e.message ?? 'Unknown error'}');
      }
    } catch (e) {
      print('[ERROR] Unexpected error during account deletion: $e');
      rethrow;
    }
  }

  /// Delete user data from your backend/database
  /// This should be implemented according to your data structure
  static Future<void> _deleteUserData(String userId) async {
    try {
      print('[DEBUG] Deleting user data for user: $userId');

      // TODO: Implement based on your backend structure
      // Examples of data you might need to delete:

      // 1. User profile data
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(userId)
      //     .delete();

      // 2. User bookings
      // final bookingsSnapshot = await FirebaseFirestore.instance
      //     .collection('bookings')
      //     .where('userId', isEqualTo: userId)
      //     .get();
      //
      // for (var doc in bookingsSnapshot.docs) {
      //   await doc.reference.delete();
      // }

      // 3. User reviews
      // final reviewsSnapshot = await FirebaseFirestore.instance
      //     .collection('reviews')
      //     .where('userId', isEqualTo: userId)
      //     .get();
      //
      // for (var doc in reviewsSnapshot.docs) {
      //   await doc.reference.delete();
      // }

      // 4. User wishlists
      // final wishlistsSnapshot = await FirebaseFirestore.instance
      //     .collection('wishlists')
      //     .where('userId', isEqualTo: userId)
      //     .get();
      //
      // for (var doc in wishlistsSnapshot.docs) {
      //   await doc.reference.delete();
      // }

      // 5. User uploaded images/files (if any)
      // You might need to delete files from Firebase Storage

      // 6. Any other user-related data in your system

      // For now, we'll simulate the data deletion
      await Future.delayed(const Duration(seconds: 2));

      print('[DEBUG] User data deletion completed');
    } catch (e) {
      print('[ERROR] Failed to delete user data: $e');
      throw Exception('Failed to delete user data: ${e.toString()}');
    }
  }

  /// Re-authenticate user before sensitive operations like account deletion
  static Future<bool> reauthenticateUser() async {
    try {
      final firebase_auth.User? firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser == null) {
        throw Exception('No authenticated user found');
      }

      // Get the user's sign-in method
      final providerData = firebaseUser.providerData;

      if (providerData.isEmpty) {
        throw Exception('No provider data found');
      }

      final providerId = providerData.first.providerId;

      switch (providerId) {
        case 'google.com':
          return await _reauthenticateWithGoogle();
        case 'apple.com':
          return await _reauthenticateWithApple();
        case 'phone':
          // For phone auth, you might want to send a new OTP
          throw Exception(
              'Phone re-authentication not implemented. Please sign out and sign back in.');
        case 'password':
          // For email/password, you would need to prompt for password
          throw Exception(
              'Email re-authentication not implemented. Please sign out and sign back in.');
        default:
          throw Exception('Unknown provider: $providerId');
      }
    } catch (e) {
      print('[ERROR] Re-authentication failed: $e');
      return false;
    }
  }

  static Future<bool> _reauthenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return false; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.currentUser?.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      print('[ERROR] Google re-authentication failed: $e');
      return false;
    }
  }

  static Future<bool> _reauthenticateWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential =
          firebase_auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      await _firebaseAuth.currentUser
          ?.reauthenticateWithCredential(oauthCredential);
      return true;
    } catch (e) {
      print('[ERROR] Apple re-authentication failed: $e');
      return false;
    }
  }

  // Mock sign in (for testing)
  static void signIn(User user) {
    _currentUser = user;
  }

  // Helper method to format phone number
  static String formatPhoneNumber(String phoneNumber, String countryCode) {
    // Remove any existing country code if present
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Remove leading zeros
    cleanNumber = cleanNumber.replaceFirst(RegExp(r'^0+'), '');

    // Add country code if not present
    if (!cleanNumber.startsWith(countryCode.replaceAll('+', ''))) {
      cleanNumber = '${countryCode.replaceAll('+', '')}$cleanNumber';
    }

    return '+$cleanNumber';
  }

  // Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    // Basic validation - should start with + and have 10-15 digits
    final RegExp phoneRegex = RegExp(r'^\+[1-9]\d{9,14}$');
    return phoneRegex.hasMatch(phoneNumber);
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
