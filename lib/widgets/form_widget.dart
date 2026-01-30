import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gem_store/validator/validator.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyForm();
}

class _MyForm extends State<MyForm> {
  String username = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //form key
  final _formKey = GlobalKey<FormState>();

  //submit
  void handleForm() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection("users").add({
        "username": usernameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "confirm_password": confirmPasswordController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });
      print("Saved to database");
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ("Create Account"),
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.start,
          ),
          Text(("Enter your name, email and password for sign up"),
              style: TextStyle(fontSize: 15)),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.name,
            autofillHints: const [AutofillHints.username],
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
                hintText: "Enter username"),
            validator: Validators.username,
          ),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email Address",
                hintText: "Enter email address"),
            validator: Validators.email,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.password],
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
                hintText: "Enter password"),
            validator: Validators.password,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.password],
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Confirm Password",
                hintText: "Enter confirm password"),
            validator: (value) =>
                Validators.confirmPassword(passwordController.text, value),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                handleForm();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
              child: Text("SIGN UP"),
            ),
          )
        ],
      ),
    );
  }
}
