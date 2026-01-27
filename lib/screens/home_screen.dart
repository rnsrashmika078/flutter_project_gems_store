import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Gem Store')),
        body: Center(child: Text('Welcome to the Gem Store!!')),
      ),
    );
  }
}
