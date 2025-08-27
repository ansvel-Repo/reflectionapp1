// import 'package:ansvel/controllers/security_controller.dart';
// import 'package:ansvel/models/security_question.dart';
// import 'package:ansvel/views/security/new_password_screen.dart';
// import 'package:ansvel/views/security/new_transaction_pin_screen.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/security_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/security_question.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/new_password_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/new_transaction_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class RecoverWithQuestionsScreen extends StatefulWidget {
  final String email;
  final bool isForPinReset;
  const RecoverWithQuestionsScreen({super.key, required this.email, this.isForPinReset = false});

  @override
  State<RecoverWithQuestionsScreen> createState() => _RecoverWithQuestionsScreenState();
}

class _RecoverWithQuestionsScreenState extends State<RecoverWithQuestionsScreen> {
  final SecurityController _securityController = SecurityController();
  final Map<String, TextEditingController> _answerControllers = {};
  final _formKey = GlobalKey<FormState>();
  late Future<List<SecurityQuestion>> _userQuestionsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userQuestionsFuture = _securityController.fetchUserQuestionsForRecovery(widget.email);
  }

  void _verifyAnswers() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      final providedAnswers = _answerControllers.map((key, value) => MapEntry(key, value.text));
      final bool isCorrect = await _securityController.verifySecurityAnswers(widget.email, providedAnswers);

      if (!mounted) return;

      if (isCorrect) {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: widget.isForPinReset
                ? const NewTransactionPinScreen()
                : NewPasswordScreen(email: widget.email),
          ),
          (route) => false,
        );
      } else {
        setState(() { _isLoading = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("One or more answers are incorrect."), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Answer Questions", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: FutureBuilder<List<SecurityQuestion>>(
        future: _userQuestionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Could not load security questions for this user."));
          }

          final questions = snapshot.data!;
          if (_answerControllers.isEmpty) {
            for (var q in questions) {
              _answerControllers[q.id] = TextEditingController();
            }
          }
          
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                Text("Answer 3 of your security questions.", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 24),
                ...questions.map((q) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _answerControllers[q.id],
                    enabled: !_isLoading,
                    decoration: InputDecoration(labelText: q.question),
                    validator: (v) => v!.isEmpty ? 'Please provide an answer' : null,
                  ),
                )).toList(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _verifyAnswers,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Verify Answers"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}