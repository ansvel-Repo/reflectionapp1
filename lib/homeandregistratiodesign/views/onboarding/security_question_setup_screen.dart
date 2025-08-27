// import 'package:ansvel/controllers/security_controller.dart';
// import 'package:ansvel/models/security_question.dart';
// import 'package:ansvel/services/encryption_service.dart';
// import 'package:ansvel/views/onboarding/13_pin_setup_screen.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/security_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/security_question.dart';
import 'package:ansvel/homeandregistratiodesign/services/encryption_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/pin_setup_screen.dart';
// import 'package:ansvel/homeandregistratiodesign/views/security/3_pin_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SecurityQuestionSetupScreen extends StatefulWidget {
  const SecurityQuestionSetupScreen({super.key});

  @override
  State<SecurityQuestionSetupScreen> createState() => _SecurityQuestionSetupScreenState();
}

class _SecurityQuestionSetupScreenState extends State<SecurityQuestionSetupScreen> {
  final List<SecurityQuestion> _selectedQuestions = [];
  final Map<String, TextEditingController> _answerControllers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final securityController = Provider.of<SecurityController>(context, listen: false);
    _selectedQuestions.addAll(securityController.allQuestions.take(5));
    for (var q in _selectedQuestions) {
      _answerControllers[q.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _answerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveAnswers() {
    if (_formKey.currentState!.validate()) {
      final securityController = Provider.of<SecurityController>(context, listen: false);
      final List<SecurityQuestionAnswer> encryptedAnswers = [];
      for (var q in _selectedQuestions) {
        final plainTextAnswer = _answerControllers[q.id]!.text;
        final encryptedAnswer = EncryptionService.encrypt(plainTextAnswer);
        encryptedAnswers.add(SecurityQuestionAnswer(questionId: q.id, answer: encryptedAnswer));
      }

      securityController.saveSecurityQuestions(encryptedAnswers);
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PinSetupScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set Up Security Questions", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text("Provide answers to 5 questions", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            ..._selectedQuestions.map((question) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: _answerControllers[question.id],
                decoration: InputDecoration(labelText: question.question),
                validator: (value) => (value == null || value.isEmpty) ? 'Please provide an answer' : null,
              ),
            )).toList(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveAnswers,
                child: const Text("Save & Continue to PIN Setup"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}