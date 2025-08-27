import 'package:ansvel/homeandregistratiodesign/models/security_question.dart';
import 'package:ansvel/homeandregistratiodesign/services/encryption_service.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SecurityController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- The complete list of 40 security questions ---
  final List<SecurityQuestion> allQuestions = const [
    SecurityQuestion(id: 'q1', question: "What was your childhood nickname?"),
    SecurityQuestion(id: 'q2', question: "What was the name of your first pet?"),
    SecurityQuestion(id: 'q3', question: "What was the name of the street you grew up on?"),
    SecurityQuestion(id: 'q4', question: "What is the name of your favorite childhood friend?"),
    SecurityQuestion(id: 'q5', question: "In what city or town did your parents meet?"),
    SecurityQuestion(id: 'q6', question: "What is your mother's maiden name?"),
    SecurityQuestion(id: 'q7', question: "What is your oldest sibling’s middle name?"),
    SecurityQuestion(id: 'q8', question: "What was the name of your elementary or primary school?"),
    SecurityQuestion(id: 'q9', question: "What was the name of your favorite teacher?"),
    SecurityQuestion(id: 'q10', question: "In what city were you born?"),
    SecurityQuestion(id: 'q11', question: "What is your favorite movie?"),
    SecurityQuestion(id: 'q12', question: "What is your favorite sports team?"),
    SecurityQuestion(id: 'q13', question: "What is the title of your favorite book?"),
    SecurityQuestion(id: 'q14', question: "What is the name of your favorite artist or band?"),
    SecurityQuestion(id: 'q15', question: "What is your all-time favorite food?"),
    SecurityQuestion(id: 'q16', question: "What is your favorite holiday?"),
    SecurityQuestion(id: 'q17', question: "What is your favorite fictional character?"),
    SecurityQuestion(id: 'q18', question: "What is your favorite historical figure?"),
    SecurityQuestion(id: 'q19', question: "What is your favorite color?"),
    SecurityQuestion(id: 'q20', question: "What is your favorite restaurant?"),
    SecurityQuestion(id: 'q21', question: "What was the make and model of your first car?"),
    SecurityQuestion(id: 'q22', question: "What was your first job?"),
    SecurityQuestion(id: 'q23', question: "Where did you go for your first international flight?"),
    SecurityQuestion(id: 'q24', question: "What was the first concert you attended?"),
    SecurityQuestion(id: 'q25', question: "What was the first album you bought?"),
    SecurityQuestion(id: 'q26', question: "In what city was your first job?"),
    SecurityQuestion(id: 'q27', question: "What was the name of the hospital where you were born?"),
    SecurityQuestion(id: 'q28', question: "What was the name of the first company you worked for?"),
    SecurityQuestion(id: 'q29', question: "What is the year of your graduation?"),
    SecurityQuestion(id: 'q30', question: "What was the first sport you ever played?"),
    SecurityQuestion(id: 'q31', question: "What is your dream job?"),
    SecurityQuestion(id: 'q32', question: "What is your dream vacation destination?"),
    SecurityQuestion(id: 'q33', question: "What is the name of a city you have always wanted to visit?"),
    SecurityQuestion(id: 'q34', question: "What is a talent you wish you had?"),
    SecurityQuestion(id: 'q35', question: "What is the name of the person you admire most?"),
    SecurityQuestion(id: 'q36', question: "What is your father's middle name?"),
    SecurityQuestion(id: 'q37', question: "What is your maternal grandmother's first name?"),
    SecurityQuestion(id: 'q38', question: "What is your paternal grandfather's first name?"),
    SecurityQuestion(id: 'q39', question: "What is your lucky number?"),
    SecurityQuestion(id: 'q40', question: "If you could have any superpower, what would it be?"),
  ];
  
  // Helper to get a user doc by email for recovery
  Future<DocumentSnapshot?> _getUserDocByEmail(String email) async {
    final querySnapshot = await _firestore.collection('Users').where('email', isEqualTo: email).limit(1).get();
    return querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null;
  }

  // Save security questions to the current user's document
  Future<void> saveSecurityQuestions(List<SecurityQuestionAnswer> answers) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in.");
    
    final questionsMap = answers.map((a) => a.toFirestore()).toList();
    await _firestore.collection('Users').doc(user.uid).update({'securityQuestions': questionsMap});
  }

  // Save encrypted PIN to the current user's document
  Future<void> saveEncryptedPin(String encryptedPin) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in.");
    
    await _firestore.collection('Users').doc(user.uid).update({'encryptedPin': encryptedPin});
  }

  // Fetch 3 random questions for a user during recovery
  Future<List<SecurityQuestion>> fetchUserQuestionsForRecovery(String email) async {
    final doc = await _getUserDocByEmail(email);
    if (doc == null || !doc.exists) throw Exception("User account not found.");

    final data = doc.data() as Map<String, dynamic>;
    final List questionsData = data['securityQuestions'] ?? [];
    if (questionsData.isEmpty) throw Exception("No security questions found for this user.");

    final userQuestionIds = questionsData.map((q) => q['questionId'] as String).toList();
    userQuestionIds.shuffle();
    final selectedIds = userQuestionIds.take(3);
    
    return allQuestions.where((q) => selectedIds.contains(q.id)).toList();
  }

  // Verify the provided answers against the stored encrypted answers
  Future<bool> verifySecurityAnswers(String email, Map<String, String> providedAnswers) async {
    final doc = await _getUserDocByEmail(email);
    if (doc == null || !doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;
    final List questionsData = data['securityQuestions'] ?? [];
    final storedAnswers = questionsData.map((q) => SecurityQuestionAnswer.fromFirestore(q)).toList();

    int correctCount = 0;
    for (var entry in providedAnswers.entries) {
      final storedAnswerObject = storedAnswers.firstWhere(
        (a) => a.questionId == entry.key,
        orElse: () => SecurityQuestionAnswer(questionId: '', answer: ''),
      );
      if (storedAnswerObject.questionId.isNotEmpty) {
        final decryptedStoredAnswer = EncryptionService.decrypt(storedAnswerObject.answer);
        if (decryptedStoredAnswer.trim().toLowerCase() == entry.value.trim().toLowerCase()) {
          correctCount++;
        }
      }
    }
    return correctCount >= 3;
  }

  // Verify the provided PIN against the stored encrypted PIN
  Future<bool> verifyPin(String email, String pin) async {
    final doc = await _getUserDocByEmail(email);
    if (doc == null || !doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;
    final encryptedPinFromDb = data['encryptedPin'] as String?;
    if (encryptedPinFromDb == null) return false;

    final decryptedPin = EncryptionService.decrypt(encryptedPinFromDb);
    return pin == decryptedPin;
  }

  // Initiate the 30-minute password reset delay
  Future<void> initiatePasswordReset(String email, String newPassword) async {
    final doc = await _getUserDocByEmail(email);
    if (doc == null) throw Exception("User account not found.");

    await _firestore.collection('Users').doc(doc.id).update({
      'pendingPassword': newPassword,
      'passwordResetTimestamp': FieldValue.serverTimestamp(),
    });
  }

  // Cancel a pending password reset
  Future<void> cancelPasswordReset(String email) async {
    final doc = await _getUserDocByEmail(email);
    if (doc == null) return;
    
    await _firestore.collection('Users').doc(doc.id).update({
      'pendingPassword': FieldValue.delete(),
      'passwordResetTimestamp': FieldValue.delete(),
    });
  }
}