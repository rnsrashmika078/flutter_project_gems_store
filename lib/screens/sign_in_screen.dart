import 'package:flutter/material.dart';
import 'package:superbase_auth/widgets/sign_in_form.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")), // optional
      body: SingleChildScrollView(   // fix overflow
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                "Welcome Back",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Text(
                "Sign in to your Account",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}