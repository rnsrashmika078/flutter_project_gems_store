import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_auth/main.dart';
import 'package:superbase_auth/screens/marketplace_screen.dart';
import 'package:superbase_auth/screens/sign_up_screen.dart';
import 'package:superbase_auth/services/supabase_auth.dart';
import 'package:superbase_auth/validator/form_validator.dart';
import 'package:superbase_auth/widgets/button_widget.dart';
import 'package:superbase_auth/widgets/custom_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await emailSignIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: "Login Successful!",
        gravity: ToastGravity.BOTTOM,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MarketplaceScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              controller: emailController,
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icons.email_outlined,
              validator: FormValidator.email, obscureText: false,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock_outline,
              obscureText: true, // Added for better UX
              validator: FormValidator.password,
            ),
            const SizedBox(height: 24),

            CustomButton(
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              buttonText: _isLoading ? "Signing In..." : "Sign In",
              onPressed: _isLoading ? null : _submitForm,
            ),

            const SizedBox(height: 16),
            const Text(
              "OR",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Google Sign In
            CustomButton(
              backgroundColor: Colors.black,
              textColor: Colors.white,
              buttonText: "Continue with Google",
              onPressed: () async {
                try {
                  if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
                    await nativeGoogleSignIn();
                  } else {
                    await supabase.auth.signInWithOAuth(OAuthProvider.google);
                  }

                  if (!mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MarketplaceScreen()),
                  );
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "Google sign in failed",
                    backgroundColor: Colors.red,
                  );
                }
              },
              buttonIcon: "assets/images/google_2.png",
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}