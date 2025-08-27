import 'package:ansvel/pin/encryption_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ansvel/referralsystem/utils/message.dart';

class ForgotPinPage extends StatefulWidget {
  const ForgotPinPage({super.key});

  @override
  State<ForgotPinPage> createState() => _ForgotPinPageState();
}

class _ForgotPinPageState extends State<ForgotPinPage> {
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final List<TextEditingController> _answerControllers = [
    TextEditingController(),
    TextEditingController()
  ];
  bool _isLoading = false;
  List<Map<String, dynamic>> _userQuestions = [];
  List<String?> _selectedQuestions = [null, null];
  List<bool> _answeredCorrectly = [false, false];
  int _attemptsRemaining = 3;

  @override
  void initState() {
    super.initState();
    _fetchSecurityQuestions();
  }

  @override
  void dispose() {
    _newPinController.dispose();
    _confirmPinController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchSecurityQuestions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data()!.containsKey('securityQuestions')) {
        setState(() {
          _userQuestions = List<Map<String, dynamic>>.from(
              doc.data()!['securityQuestions']);
          if (_userQuestions.isNotEmpty) {
            _selectedQuestions[0] = _userQuestions[0]['question'];
            if (_userQuestions.length > 1) {
              _selectedQuestions[1] = _userQuestions[1]['question'];
            }
          }
        });
      }
    }
  }

  String _normalizeAnswer(String answer) {
    // Remove leading/trailing whitespace and convert to lowercase
    return answer.trim().toLowerCase();
  }

  Future<void> _verifyAnswersAndResetPin() async {
    if (_selectedQuestions.any((q) => q == null) || _userQuestions.isEmpty) {
      showMessage(context, "Please select all security questions");
      return;
    }

    if (_answerControllers.any((c) => c.text.isEmpty)) {
      showMessage(context, "Please answer all selected questions");
      return;
    }

    if (_newPinController.text.length != 4 ||
        _confirmPinController.text.length != 4) {
      showMessage(context, "PIN must be 4 digits");
      return;
    }

    if (_newPinController.text != _confirmPinController.text) {
      showMessage(context, "PINs do not match");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Verify both answers
      int correctAnswers = 0;
      for (int i = 0; i < 2; i++) {
        final selectedQnA = _userQuestions.firstWhere(
          (q) => q['question'] == _selectedQuestions[i],
          orElse: () => {},
        );

        if (selectedQnA.isNotEmpty &&
            _normalizeAnswer(selectedQnA['answer'].toString()) ==
                _normalizeAnswer(_answerControllers[i].text)) {
          correctAnswers++;
          _answeredCorrectly[i] = true;
        } else {
          _answeredCorrectly[i] = false;
        }
      }

      if (correctAnswers < 2) {
        setState(() {
          _attemptsRemaining--;
          _isLoading = false;
        });
        showMessage(
            context,
            "Incorrect answers. You need at least 2 correct answers. "
            "Attempts remaining: $_attemptsRemaining");
        
        if (_attemptsRemaining <= 0) {
          showMessage(context, "No attempts remaining. Please try again later.");
          Navigator.pop(context);
        }
        return;
      }

      // If we get here, at least 2 answers are correct
      final encryptedPin = EncryptionUtil.encryptPin(_newPinController.text);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({
          'pin': encryptedPin,
        });

        showMessage(context, "PIN reset successfully!");
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
        title: const Text("Reset PIN"),
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
            const Icon(Icons.lock_reset, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              "Reset Your PIN",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Answer at least 2 of your 3 security questions correctly to reset your PIN",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: _attemptsRemaining < 3 ? FontWeight.bold : null,
              ),
            ),
            if (_attemptsRemaining < 3)
              Text(
                "Attempts remaining: $_attemptsRemaining",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 30),
            if (_userQuestions.isNotEmpty) ...[
              // First question dropdown and answer field
              Text(
                "Your security questions:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(2, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedQuestions[index],
                      decoration: InputDecoration(
                        labelText: "Question ${index + 1}",
                        border: const OutlineInputBorder(),
                        filled: _answeredCorrectly[index],
                        fillColor: Colors.green[50],
                      ),
                      items: _userQuestions.map((question) {
                        return DropdownMenuItem<String>(
                          value: question['question'],
                          child: Text(
                            question['question'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedQuestions[index] = value;
                          _answeredCorrectly[index] = false;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _answerControllers[index],
                      decoration: InputDecoration(
                        labelText: "Answer for Question ${index + 1}",
                        border: const OutlineInputBorder(),
                        filled: _answeredCorrectly[index],
                        fillColor: Colors.green[50],
                      ),
                      onChanged: (value) {
                        setState(() {
                          _answeredCorrectly[index] = false;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),
              const SizedBox(height: 20),
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
                onPressed: _isLoading ? null : _verifyAnswersAndResetPin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Reset PIN",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ] else if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              const Text(
                "No security questions found for your account",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}