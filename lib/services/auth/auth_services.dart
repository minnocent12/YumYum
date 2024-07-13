import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // Check if email is already in use
  Future<bool> isEmailAlreadyInUse(String email) async {
    try {
      final result = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return result.isNotEmpty;
    } catch (e) {
      print("Error checking if email is in use: $e");
      return false;
    }
  }

  // Check if email is registered
  Future<bool> isEmailRegistered(String email) async {
    try {
      final result = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return result.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException error: ${e.code}");
      return false;
    } catch (e) {
      print("Unknown error: $e");
      return false;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }
}
