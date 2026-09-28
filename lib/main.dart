import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'utils/app_theme.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/order_viewmodel.dart';
import 'viewmodels/splash_viewmodel.dart';
import 'views/splash/splash_screen.dart';

// ================= MAIN START =================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ShopEasyApp());
}

// ================= MAIN END =================

// ================= APP START =================

class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ================= PROVIDERS START =================

      providers: [
        ChangeNotifierProvider(
          create: (_) => SplashViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderViewModel(),
        ),
      ],

      // ================= PROVIDERS END =================

      child: MaterialApp(
        // ================= APP SETTINGS START =================

        debugShowCheckedModeBanner: false,
        title: 'ShopEasy',
        theme: AppTheme.light,

        // ================= APP SETTINGS END =================

        // ================= FIRST SCREEN START =================

        home: const SplashScreen(),

        // ================= FIRST SCREEN END =================
      ),
    );
  }
}

// ================= APP END =================