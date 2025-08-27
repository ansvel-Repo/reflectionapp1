import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/features/features.dart';

abstract class RequestsRepository {
  Future<void> sendContactRequest(ContactRequest request);
  Stream<bool> isContactRequestReceived(String senderId);
  Stream<bool> isContactRequestSent(String receiverId);
  Future<void> addUserToContacts(ContactRequest request);
  Future<void> removeRequest(ContactRequest request);
  Future<void> cancelRequest(String receiverId);
  Stream<bool> isUserMyContact(String userId);
  Query<ContactRequest> queryRequests();
  Stream<int> totalRequests();
}
