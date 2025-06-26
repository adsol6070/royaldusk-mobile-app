// Simple auth state management
import 'package:royaldusk_mobile_app/models/user.dart';

class AuthService {
  static User? _currentUser;

  static bool get isSignedIn => _currentUser != null;
  static User? get currentUser => _currentUser;

  static void signIn(User user) {
    _currentUser = user;
  }

  static void signOut() {
    _currentUser = null;
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
