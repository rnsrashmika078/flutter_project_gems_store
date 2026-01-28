import 'package:flutter/material.dart';

void main(){
  return runApp(UserRegistration());
}

class UserRegistration extends StatefulWidget{
  const UserRegistration({super.key});
  @override
  State<UserRegistration> createState() => _UserRegistration();
}
class _UserRegistration extends State<UserRegistration>{
  //username 
  //email
  //password
  //confirm password
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration"),),
       body: Center(
        child: Column(
          children: [Text("Registration Form")],
        ),
       ),
    );
  }
}