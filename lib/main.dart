import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gem_store/firebase_options.dart';
import 'package:gem_store/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Home());
}
