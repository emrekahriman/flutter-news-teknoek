import 'package:flutter/material.dart';
import 'package:teknoek/screens/home.dart';
import 'package:teknoek/screens/login.dart';
import 'package:teknoek/services/service.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // check if user token is valid and user if exists
    Service().checkToken().then((isLoggedIn) {
      // Wait 1 second and then navigate to login or home page
      Future.delayed(const Duration(seconds: 1), () async {
        if (isLoggedIn) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false);
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222324),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(image: AssetImage('assets/images/logo.png'), width: 100),
          ],
        ),
      ),
    );
  }
}
