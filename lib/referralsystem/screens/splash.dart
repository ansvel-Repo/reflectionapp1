import 'package:ansvel/loginapp/src/features/authentication/screens/login/login_screen.dart';
import 'package:ansvel/referralsystem/screens/refhomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ansvel/referralsystem/screens/authentication/login.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  void navigate() {
    Future.delayed(const Duration(seconds: 2), () {
      if (auth.currentUser != null) {
        ///Navigate to home screen
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => const RefHomePage()),
            (route) => false);
      } else {
        ///Navigate to login screen
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(),
      ),
    );
  }
}
