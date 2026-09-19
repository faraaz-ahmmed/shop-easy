import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> start() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}