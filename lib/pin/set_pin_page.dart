// import 'package:ansvel/loginapp/src/features/authentication/screens/completesignup/completesignup.dart';
import 'package:ansvel/payment/initialdeposit/initialdeposit.dart';
import 'package:ansvel/pin/encryption_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ansvel/referralsystem/utils/message.dart';


class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final List<Map<String, String>> _securityQuestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with 3 empty security questions
    for (int i = 0; i < 3; i++) {
      _securityQuestions.add({'question': '', 'answer': ''});
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  String _normalizeAnswer(String answer) {
    return answer.trim().toLowerCase();
  }

  Future<void> _savePinAndQuestions() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate that all security questions are selected and answered
    for (var question in _securityQuestions) {
      if (question['question']!.isEmpty || question['answer']!.isEmpty) {
        showMessage(context, "Please select and answer all security questions");
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final encryptedPin = EncryptionUtil.encryptPin(_pinController.text);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Normalize all answers before saving
        final normalizedQuestions = _securityQuestions.map((question) {
          return {
            'question': question['question'],
            'answer': _normalizeAnswer(question['answer']!),
          };
        }).toList();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({
          'pin': encryptedPin,
          'securityQuestions': normalizedQuestions,
        });

        showMessage(context, "PIN set successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const InitialDepositScreen(),
          ),
        );
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
        title: const Text("Set Your PIN"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Create a 4-digit PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "Enter PIN",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a PIN";
                  }
                  if (value.length != 4) {
                    return "PIN must be 4 digits";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "Confirm PIN",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                validator: (value) {
                  if (value != _pinController.text) {
                    return "PINs do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              const Text(
                "Security Questions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Please select and answer 3 security questions",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),
              ...List.generate(3, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select Question ${index + 1}",
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      isExpanded: true,
                      items: securityQuestions
                          .where((question) => !_securityQuestions
                              .any((q) => q['question'] == question))
                          .map((question) {
                        return DropdownMenuItem<String>(
                          value: question,
                          child: Text(
                            question,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _securityQuestions[index]['question'] = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a question";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Answer",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      ),
                      onChanged: (value) {
                        _securityQuestions[index]['answer'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please provide an answer";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _savePinAndQuestions,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save PIN",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}