import 'package:ansvel/homeandregistratiodesign/views/onboarding/onboarding_screen.dart';
import 'package:ansvel/main.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    final prefs = await SharedPreferences.getInstance();
    final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => showOnboarding ? const OnboardingScreen() : const AuthWrapper(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1128),
      body: Center(
        child: ScaleTransition(
          scale: _logoScaleAnimation,
          child: Image.asset('assets/images/ansvel_logo.png', width: 150),
        ),
      ),
    );
  }
}