import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  Future<bool> start() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = await FirebaseAuth.instance.authStateChanges().first;
    return user != null;
  }
}