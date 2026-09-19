import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool hidePassword = true;
  String? errorMessage;

  void togglePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return _runAuth(
      () => _authService.login(
        email: email,
        password: password,
      ),
    );
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _runAuth(
      () => _authService.signUp(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<bool> _runAuth(
    Future<void> Function() action,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on FirebaseAuthException catch (error) {
      errorMessage = _firebaseMessage(error.code);
      return false;
    } catch (_) {
      errorMessage = 'Something went wrong. Try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _firebaseMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email.';

      case 'user-not-found':
      case 'invalid-credential':
        return 'Email or password is incorrect.';

      case 'wrong-password':
        return 'Email or password is incorrect.';

      case 'email-already-in-use':
        return 'This email is already registered.';

      case 'weak-password':
        return 'Please use a stronger password.';

      case 'network-request-failed':
        return 'Check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Try again later.';

      default:
        return 'Authentication failed. Try again.';
    }
  }
}