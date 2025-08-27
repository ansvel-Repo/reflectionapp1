
import 'package:ansvel/pin/encryption_util.dart';
import 'package:ansvel/pin/forgot_pin_page.dart';
import 'package:ansvel/pin/change_pin_page.dart'; // Add this import
import 'package:ansvel/homeandregistratiodesign/views/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ansvel/referralsystem/utils/message.dart';


class VerifyPinPage extends StatefulWidget {
  const VerifyPinPage({super.key});

  @override
  State<VerifyPinPage> createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<VerifyPinPage> {
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;
  String? _encryptedPin;

  @override
  void initState() {
    super.initState();
    _fetchUserPin();
  }

  Future<void> _fetchUserPin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _encryptedPin = doc.data()?['pin'];
        });
      }
    }
  }

  Future<void> _verifyPin() async {
    if (_encryptedPin == null) {
      showMessage(context, "No PIN found for this user");
      return;
    }

    if (_pinController.text.length != 4) {
      showMessage(context, "PIN must be 4 digits");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final decryptedPin = EncryptionUtil.decryptPin(_encryptedPin!);
      if (decryptedPin == _pinController.text) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavWithAnimatedIcons(),
          ),
        );
      } else {
        showMessage(context, "Incorrect PIN. Please try again.");
      }
    } catch (e) {
      showMessage(context, "Error verifying PIN: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Your PIN"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 30),
            const Text(
              "Enter your 4-digit PIN to continue",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyPin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Verify PIN",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPinPage(),
                      ),
                    );
                  },
                  child: const Text("Forgot PIN?"),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePinPage(),
                      ),
                    );
                  },
                  child: const Text("Change PIN"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
