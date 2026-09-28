import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../home/home_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  // ================= LOGIN FUNCTION START =================

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    final auth = context.read<AuthViewModel>();

    final success = await auth.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ?? 'Login failed.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================= LOGIN FUNCTION END =================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      // ================= BACKGROUND START =================

      body: Stack(
        children: [
          const Positioned(
            left: -80,
            right: -80,
            bottom: -150,
            child: CircleAvatar(
              radius: 170,
              backgroundColor: Color(0x33009966),
            ),
          ),

          // ================= BACKGROUND END =================

          // ================= BODY START =================

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 25,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // ================= LOGO START =================

                        const _ShopLogo(),

                        // ================= LOGO END =================

                        const SizedBox(height: 25),

                        // ================= TITLE START =================

                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Login to continue shopping',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 15,
                          ),
                        ),

                        // ================= TITLE END =================

                        const SizedBox(height: 28),

                        // ================= EMAIL START =================

                        TextFormField(
                          controller: emailController,
                          keyboardType:
                              TextInputType.emailAddress,
                          textInputAction:
                              TextInputAction.next,
                          decoration:
                              const InputDecoration(
                            hintText: 'Email Address',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
                          ),
                          validator: (value) {
                            final email =
                                value?.trim() ?? '';

                            if (email.isEmpty) {
                              return 'Please enter your email';
                            }

                            if (!email.contains('@') ||
                                !email.contains('.')) {
                              return 'Please enter a valid email';
                            }

                            return null;
                          },
                        ),

                        // ================= EMAIL END =================

                        const SizedBox(height: 14),

                        // ================= PASSWORD START =================

                        TextFormField(
                          controller: passwordController,
                          obscureText: hidePassword,
                          textInputAction:
                              TextInputAction.done,
                          onFieldSubmitted: (_) {
                            if (!auth.isLoading) {
                              login();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword =
                                      !hidePassword;
                                });
                              },
                              icon: Icon(
                                hidePassword
                                    ? Icons
                                          .visibility_outlined
                                    : Icons
                                          .visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            final password =
                                value ?? '';

                            if (password.isEmpty) {
                              return 'Please enter your password';
                            }

                            if (password.length < 6) {
                              return 'Minimum 6 characters required';
                            }

                            return null;
                          },
                        ),

                        // ================= PASSWORD END =================

                        const SizedBox(height: 24),

                        // ================= LOGIN BUTTON START =================

                        ElevatedButton(
                          onPressed:
                              auth.isLoading ? null : login,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                              double.infinity,
                              52,
                            ),
                            backgroundColor:
                                AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child:
                                      CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                        ),

                        // ================= LOGIN BUTTON END =================

                        const SizedBox(height: 22),

                        // ================= SIGNUP START =================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: AppColors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: auth.isLoading
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const SignUpScreen(),
                                        ),
                                      );
                                    },
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ),

                        // ================= SIGNUP END =================
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ================= BODY END =================
        ],
      ),
    );
  }
}

// ================= SHOP LOGO START =================

class _ShopLogo extends StatelessWidget {
  const _ShopLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.shopping_cart_outlined,
          color: AppColors.darkGreen,
          size: 48,
        ),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: 'Shop'),
              TextSpan(
                text: 'Easy',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ================= SHOP LOGO END =================