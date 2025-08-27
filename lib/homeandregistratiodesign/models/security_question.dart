// A single security question from the master list
class SecurityQuestion {
  final String id;
  final String question;

  const SecurityQuestion({required this.id, required this.question});
}

// A class to link a user's answer to a specific question's ID
class SecurityQuestionAnswer {
  final String questionId;
  final String answer; // This will store the ENCRYPTED answer

  SecurityQuestionAnswer({required this.questionId, required this.answer});

  // Factory constructor to create an instance from a Firestore map
  factory SecurityQuestionAnswer.fromFirestore(Map<String, dynamic> data) {
    return SecurityQuestionAnswer(
      questionId: data['questionId'] ?? '',
      answer: data['answer'] ?? '',
    );
  }

  // Helper method to convert this object into a Map for saving to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'questionId': questionId,
      'answer': answer,
    };
  }
}