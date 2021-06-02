import 'package:firebase_auth/firebase_auth.dart';

/// Class to handle authentication steps.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login user with email and password, returns user credential.
  Future<UserCredential> loginUser(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  /// Regester user with email and password, returns user credential.
  Future<UserCredential> createUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  /// Logout user, returns [true] if successful
  /// [false] if failure.
  bool logoutUser() {
    try {
      _auth.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }
}
