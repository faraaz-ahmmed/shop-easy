import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
      TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  // ================= SIGNUP START =================

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    final auth = context.read<AuthViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final success = await auth.signUp(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // Signup کے بعد user کو Login کرنا ہوگا
      await auth.logout();

      if (!mounted) return;

      Navigator.pop(context);

      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully. Please login now.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ?? 'Signup failed.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================= SIGNUP END =================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 25,
              ),
              child: Center(
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
                          'Create Account',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Sign up to start shopping',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 15,
                          ),
                        ),

                        // ================= TITLE END =================

                        const SizedBox(height: 25),

                        // ================= NAME START =================

                        TextFormField(
                          controller: nameController,
                          textInputAction:
                              TextInputAction.next,
                          textCapitalization:
                              TextCapitalization.words,
                          decoration:
                              const InputDecoration(
                            hintText: 'Full Name',
                            prefixIcon: Icon(
                              Icons.person_outline,
                            ),
                          ),
                          validator: (value) {
                            final name =
                                value?.trim() ?? '';

                            if (name.isEmpty) {
                              return 'Please enter your name';
                            }

                            if (name.length < 3) {
                              return 'Name must contain at least 3 characters';
                            }

                            return null;
                          },
                        ),

                        // ================= NAME END =================

                        const SizedBox(height: 14),

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
                              TextInputAction.next,
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
                              return 'Please enter a password';
                            }

                            if (password.length < 6) {
                              return 'Minimum 6 characters required';
                            }

                            return null;
                          },
                        ),

                        // ================= PASSWORD END =================

                        const SizedBox(height: 14),

                        // ================= CONFIRM PASSWORD START =================

                        TextFormField(
                          controller:
                              confirmPasswordController,
                          obscureText:
                              hideConfirmPassword,
                          textInputAction:
                              TextInputAction.done,
                          onFieldSubmitted: (_) {
                            if (!auth.isLoading) {
                              signUp();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword =
                                      !hideConfirmPassword;
                                });
                              },
                              icon: Icon(
                                hideConfirmPassword
                                    ? Icons
                                          .visibility_outlined
                                    : Icons
                                          .visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Please confirm your password';
                            }

                            if (value !=
                                passwordController.text) {
                              return 'Passwords do not match';
                            }

                            return null;
                          },
                        ),

                        // ================= CONFIRM PASSWORD END =================

                        const SizedBox(height: 24),

                        // ================= SIGNUP BUTTON START =================

                        ElevatedButton(
                          onPressed: auth.isLoading
                              ? null
                              : signUp,
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
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                        ),

                        // ================= SIGNUP BUTTON END =================

                        const SizedBox(height: 22),

                        // ================= LOGIN START =================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: AppColors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: auth.isLoading
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                    },
                              child: const Text('Login'),
                            ),
                          ],
                        ),

                        // ================= LOGIN END =================
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