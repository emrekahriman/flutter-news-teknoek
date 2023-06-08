import 'package:flutter/material.dart';
import 'package:teknoek/utilities/palette.dart';
import 'package:teknoek/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      theme: ThemeData(
        primarySwatch: Palette.yek,
      ),
      home: const Splash(),
    );
  }
}
