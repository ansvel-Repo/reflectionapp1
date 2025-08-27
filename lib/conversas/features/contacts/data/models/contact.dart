import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ansvel/conversas/common/common.dart';

class Contact extends Equatable {
  final String id;
  final String contactId;
  final Timestamp createdAt;

  const Contact({
    required this.id,
    required this.contactId,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, contactId, createdAt];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FirebaseFieldName.id: id,
      FirebaseFieldName.contactId: contactId,
      FirebaseFieldName.createdAt: createdAt,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> map) {
    return Contact(
      id: map[FirebaseFieldName.id] as String,
      contactId: map[FirebaseFieldName.contactId] as String,
      createdAt: map[FirebaseFieldName.createdAt] ?? Timestamp.now(),
    );
  }

  Contact copyWith({String? id, String? contactId, Timestamp? createdAt}) {
    return Contact(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
