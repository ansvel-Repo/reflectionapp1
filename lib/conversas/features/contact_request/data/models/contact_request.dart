import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:equatable/equatable.dart';

class ContactRequest extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final RequestStatus status;
  final Timestamp createdAt;

  const ContactRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object> get props {
    return [id, senderId, receiverId, status, createdAt];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FirebaseFieldName.id: id,
      FirebaseFieldName.senderId: senderId,
      FirebaseFieldName.receiverId: receiverId,
      FirebaseFieldName.status: status.name,
      FirebaseFieldName.createdAt: createdAt,
    };
  }

  factory ContactRequest.fromJson(Map<String, dynamic> map) {
    return ContactRequest(
      id: map[FirebaseFieldName.id] as String,
      senderId: map[FirebaseFieldName.senderId] as String,
      receiverId: map[FirebaseFieldName.receiverId] as String,
      status: RequestStatus.stringToRequestStatus(
        map[FirebaseFieldName.status] as String,
      ),
      createdAt: map[FirebaseFieldName.createdAt] ?? Timestamp.now(),
    );
  }

  ContactRequest copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    RequestStatus? status,
    Timestamp? createdAt,
  }) {
    return ContactRequest(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
