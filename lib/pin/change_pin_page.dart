import 'package:ansvel/pin/encryption_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ansvel/referralsystem/utils/message.dart';


class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
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

  Future<void> _changePin() async {
    if (_encryptedPin == null) {
      showMessage(context, "No PIN found for this user");
      return;
    }

    if (_currentPinController.text.length != 4 ||
        _newPinController.text.length != 4 ||
        _confirmPinController.text.length != 4) {
      showMessage(context, "PIN must be 4 digits");
      return;
    }

    if (_newPinController.text != _confirmPinController.text) {
      showMessage(context, "New PINs do not match");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final decryptedPin = EncryptionUtil.decryptPin(_encryptedPin!);
      if (decryptedPin != _currentPinController.text) {
        showMessage(context, "Current PIN is incorrect");
        return;
      }

      final encryptedNewPin = EncryptionUtil.encryptPin(_newPinController.text);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({
          'pin': encryptedNewPin,
        });

        showMessage(context, "PIN changed successfully!");
        Navigator.pop(context);
      }
    } catch (e) {
      showMessage(context, "Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change PIN"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              "Change Your PIN",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _currentPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Current PIN",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "New PIN",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Confirm New PIN",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _changePin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Change PIN",
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}