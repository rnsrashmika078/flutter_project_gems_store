import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_auth/main.dart';
import 'package:superbase_auth/provider/auth_provider.dart';
import 'package:superbase_auth/screens/user_profile.dart';
import 'package:superbase_auth/services/supabase_auth.dart';
import 'package:superbase_auth/services/supabase_services.dart';
import 'package:superbase_auth/validator/form_validator.dart';
import 'package:superbase_auth/widgets/button_widget.dart';
import 'package:superbase_auth/widgets/custom_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpForm();
}

class _SignUpForm extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      ref.read(userNameProvider.notifier).state = username.text;

      await emailSignUp(email.text.trim(), password.text.trim());
      // await insertData(user_id, email.text.trim(), username.text.trim(), null);
      Fluttertoast.showToast(
        msg: "Registration Success!",
        gravity: ToastGravity.BOTTOM,
      );
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => Store()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          spacing: 14,
          children: [
            CustomTextField(
              controller: username,
              labelText: 'Username',
              hintText: 'Enter username',
              prefixIcon: Icons.email_outlined,
              suffixIcon: Icons.check_circle_outline,
              validator: FormValidator.username,
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                  "Forgot login details?",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  "Reset",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            CustomButton(
              backgroundColor: Colors.blue,
              iconSize: 25,
              buttonText: "Sign in",
              onPressed: submitForm,
            ),
            // sign in with google
            CustomButton(
              backgroundColor: Colors.black,
              iconSize: 25,
              buttonText: "Sign with Google",
              onPressed: () async {
                if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
                  await nativeGoogleSignIn();
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Store()),
                  );
                } else {
                  await supabase.auth.signInWithOAuth(OAuthProvider.google);
                }
              },
              buttonIcon: ("assets/images/google_2.png"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
