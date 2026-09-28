import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;

  User? get currentUser => _auth.currentUser;

  // ================= LOGIN START =================

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _startLoading();

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return true;
    } on FirebaseAuthException catch (error) {
      errorMessage = _loginError(error.code);
      return false;
    } catch (_) {
      errorMessage =
          'Something went wrong. Please try again.';
      return false;
    } finally {
      _stopLoading();
    }
  }

  // ================= LOGIN END =================

  // ================= SIGNUP START =================

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _startLoading();

      final credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;

      if (user == null) {
        errorMessage =
            'Account could not be created.';
        return false;
      }

      await user.updateDisplayName(name.trim());

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
        'name': name.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'hasLoggedInBefore': false,
      });

      return true;
    } on FirebaseAuthException catch (error) {
      errorMessage = _signUpError(error.code);
      return false;
    } catch (_) {
      errorMessage =
          'Something went wrong. Please try again.';
      return false;
    } finally {
      _stopLoading();
    }
  }

  // ================= SIGNUP END =================

  // ================= LOGOUT START =================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ================= LOGOUT END =================

  // ================= LOADING START =================

  void _startLoading() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  // ================= LOADING END =================

  // ================= LOGIN ERRORS START =================

  String _loginError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Account not found. Please sign up first, then login.';

      case 'invalid-credential':
        return 'Account not found or password is incorrect. Please sign up first if you do not have an account.';

      case 'wrong-password':
        return 'Incorrect password. Please try again.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return 'Login failed. Please try again.';
    }
  }

  // ================= LOGIN ERRORS END =================

  // ================= SIGNUP ERRORS START =================

  String _signUpError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please login.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password must contain at least 6 characters.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return 'Signup failed. Please try again.';
    }
  }

  // ================= SIGNUP ERRORS END =================
}