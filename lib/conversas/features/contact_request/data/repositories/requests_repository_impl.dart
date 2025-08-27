import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/features/features.dart';

class RequestsRepositoryImpl implements RequestsRepository {
  final RequestsDataSource _datasource;
  RequestsRepositoryImpl(this._datasource);

  @override
  Future<void> sendContactRequest(ContactRequest request) async {
    try {
      await _datasource.sendContactRequest(request);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  //Request contact methods
  @override
  Stream<int> totalRequests() async* {
    try {
      yield* _datasource.totalRequests();
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> removeRequest(ContactRequest request) async {
    try {
      await _datasource.removeRequest(request);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> addUserToContacts(ContactRequest request) async {
    try {
      await _datasource.addUserToContacts(request);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  //check if the current user send
  //a request to the specified userId (receiverId)
  @override
  Stream<bool> isContactRequestSent(String receiverId) async* {
    try {
      yield* _datasource.isContactRequestSent(receiverId);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  //check if the current user received
  //a request from the specified userId (sender)
  @override
  Stream<bool> isContactRequestReceived(String senderId) async* {
    try {
      yield* _datasource.isContactRequestReceived(senderId);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  //check if the user is on the current user contact list
  @override
  Stream<bool> isUserMyContact(String userId) async* {
    try {
      yield* _datasource.isUserMyContact(userId);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> cancelRequest(String receiverId) async {
    try {
      await _datasource.cancelRequest(receiverId);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Query<ContactRequest> queryRequests() {
    try {
      return _datasource.queryRequests().withConverter(
        fromFirestore: (snapshot, _) =>
            ContactRequest.fromJson(snapshot.data() as Map<String, dynamic>),
        toFirestore: (chat, _) => chat.toJson(),
      );
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }
}
