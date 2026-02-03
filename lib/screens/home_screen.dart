import 'package:flutter/material.dart';
import 'package:superbase_auth/screens/sign_up_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? authUserData;
  const HomeScreen({super.key, required this.authUserData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SignUpScreen(),
        // Text(authUserData?['name'] ?? "Not Signed in!"),
        // ElevatedButton(onPressed: signOut, child: Icon(Icons.logout)),
      ],
    );
  }
}
