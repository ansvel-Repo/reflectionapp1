
import 'dart:io';
import 'dart:typed_data';
import 'package:ansvel/homeandregistratiodesign/views/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_feedback/my_feedback.dart';
import 'package:my_feedback/provider/feedback_provider.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool _isSubmitting = false;

  Future<void> _submitFeedback(BuildContext context) async {
    final feedback = await MyFeedbackCaller.showFeedbackModalWithResult(
      context,
      userId: FirebaseAuth.instance.currentUser?.email ?? 'unknown',
      onResult: (FeedbackMediaResultModel) {},
    );

    if (feedback != null) {
      setState(() => _isSubmitting = true);

      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      String feedbackId =
          FirebaseFirestore.instance.collection('feedback').doc().id;
      String timestamp = DateTime.now().toIso8601String();

      // Here you can process the feedback and store it in Firebase
      await FirebaseFirestore.instance
          .collection('feedback')
          .doc(feedbackId)
          .set({
        'userId': userId,
        'email_id': FirebaseAuth.instance.currentUser?.email ?? 'unknown',
        'message': feedback.message,
        'feedback_type': feedback.type,
        'media': feedback.media,
        'timestamp': timestamp,
      });

      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Submit Feedback",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.shade400,
        elevation: 5,
        shadowColor: Colors.deepPurple.shade100,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
            weight: 500,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavWithAnimatedIcons()),
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.feedback,
                    size: 80,
                    color: Colors.deepPurpleAccent,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "We value your feedback!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Let us know your thoughts, suggestions, or any issues you've faced.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed:
                          _isSubmitting ? null : () => _submitFeedback(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Give Feedback",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
