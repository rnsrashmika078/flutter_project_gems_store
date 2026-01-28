import 'package:flutter/material.dart';
import 'package:gem_store/widget/form_widget.dart';

void main() {
  return runApp(UserRegistration());
}

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});
  @override
  State<UserRegistration> createState() => _UserRegistration();
}

class _UserRegistration extends State<UserRegistration> {
 
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(22),
        child: MyForm() );
  }
}
