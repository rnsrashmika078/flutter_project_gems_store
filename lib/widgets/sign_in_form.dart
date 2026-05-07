// sign_in_form.dart
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
  ConsumerState<SignInForm> createState() => _SignInForm();
}

class _SignInForm extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  void submitForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        await emailSignIn(email.text.trim(), password.text.trim());

        Fluttertoast.showToast(
          msg: "Login Success!",
          gravity: ToastGravity.BOTTOM,
        );

        if (!context.mounted || !mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MarketplaceScreen()),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 14,
          children: [
            CustomTextField(
              controller: email,
              labelText: 'Email',
              hintText: 'Enter Your Email Address',
              prefixIcon: Icons.email_outlined,
              suffixIcon: Icons.check_circle_outline,
              validator: FormValidator.email,
            ),
            CustomTextField(
              controller: password,
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              suffixIcon: Icons.check_circle_outline,
              validator: FormValidator.password,
            ),
            CustomButton(
              backgroundColor: Colors.blue,
              iconSize: 25,
              textColor: Colors.white,
              buttonText: "Sign In",
              onPressed: submitForm,
            ),
            Text("OR", style: TextStyle(color: Colors.grey, fontSize: 16)),
            // Sign in with Google
            CustomButton(
              backgroundColor: Colors.black,
              iconSize: 25,
              textColor: Colors.white,
              buttonText: "Sign in with Google",
              onPressed: () async {
                if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
                  await nativeGoogleSignIn();
                } else {
                  await supabase.auth.signInWithOAuth(OAuthProvider.google);
                }
              },
              buttonIcon: "assets/images/google_2.png",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
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
