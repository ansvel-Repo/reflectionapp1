import 'package:cloud_firestore/cloud_firestore.dart';

enum AdActionType { WebLink, InAppPage }

class AdSlide {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String buttonText;
  final AdActionType actionType;
  final String actionTarget;

  AdSlide({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.actionType,
    required this.actionTarget,
  });

  factory AdSlide.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AdSlide(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      buttonText: data['buttonText'] ?? 'Learn More',
      actionType: AdActionType.values.firstWhere(
        (e) => e.toString() == data['actionType'],
        orElse: () => AdActionType.WebLink,
      ),
      actionTarget: data['actionTarget'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'subtitle': subtitle,
      'buttonText': buttonText,
      'actionType': actionType.toString(),
      'actionTarget': actionTarget,
    };
  }
}