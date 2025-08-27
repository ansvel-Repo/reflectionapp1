import 'package:ansvel/loginapp/src/features/authentication/screens/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:ansvel/custombottomnavigation/bottom_nav_with_animated_icons.dart';

class VerificationPendingScreen extends StatefulWidget {
  const VerificationPendingScreen({super.key});

  @override
  State<VerificationPendingScreen> createState() =>
      _VerificationPendingScreenState();
}

class _VerificationPendingScreenState extends State<VerificationPendingScreen> {
  bool _isLoading = false;

  Future<void> _completeSignupAndNavigate() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get device information
        final deviceInfo = await _getDeviceInfo();

        // Update user document
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({
          'completedsignup': true,
          'registeredDeviceId': deviceInfo['deviceId'],
          'deviceInfo': deviceInfo,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        return {
          'deviceId': androidInfo.id,
          'deviceType': 'Android',
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'version': androidInfo.version.release,
        };
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        return {
          'deviceId': iosInfo.identifierForVendor,
          'deviceType': 'iOS',
          'model': iosInfo.model,
          'name': iosInfo.name,
          'systemVersion': iosInfo.systemVersion,
        };
      }
    } on PlatformException {
      return {'deviceId': 'unknown', 'deviceType': 'unknown'};
    }
    return {'deviceId': 'unknown', 'deviceType': 'unknown'};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Lottie.asset(
                  'assets/animations/background_waves.json',
                  fit: BoxFit.cover,
                  options: LottieOptions(enableApplyingOpacityToLayers: true),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/verification_pending.json',
                      width: 250,
                      height: 250,
                      repeat: true,
                      options: LottieOptions(enableApplyingOpacityToLayers: true),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Verification in Progress',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Thank you for signing up with Ansvel!',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'We are verifying the details you provided and conducting address verification. '
                            'This process typically takes up to 24 hours.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Kindly click the button below to complete the setup process.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.amber[200],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Please check back after 24 hours',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.amber[200],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading ? null : _completeSignupAndNavigate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6A11CB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                'Complete Setup',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}