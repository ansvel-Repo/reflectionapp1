import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestsDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  RequestsDataSource(this._firestore, this._auth);

  String? get _currentUserId => _auth.currentUser?.uid;

  //add user to contact request contact (like, accept you as a friend)
  Future<void> addUserToContacts(ContactRequest request) async {
    //get the senderId
    final senderId = request.senderId;

    //deleting request
    await _deleteRequest(request);

    //creating a contact with the id of the request sender
    final contact = Contact(
      id: '',
      contactId: senderId,
      createdAt: Timestamp.now(),
    );

    final result = await _currentUserContactsCollectionRef().add(
      contact.toJson(),
    );

    final contactId = result.id;

    await Future.wait([
      //save contact into the current user's list
      _currentUserContactsCollectionRef().doc(contactId).update({
        FirebaseFieldName.id: contactId,
      }),

      //save current user into sender's contact list
      _saveCurrentUserToSenderContacts(senderId, contactId),
    ]);
  }

  Future<void> _saveCurrentUserToSenderContacts(
    String senderId,
    String contactId,
  ) async {
    //current userId [_currentUserId] is the one that receives the request

    if (_currentUserId != null) {
      //creating a contact with the id of the request sender
      final contact = Contact(
        id: contactId,
        contactId: '$_currentUserId',
        createdAt: Timestamp.now(),
      );

      //save contact into the sender's user list
      await _senderUserContactsCollectionRef(
        senderId,
      ).doc(contactId).set(contact.toJson());
    }
  }

  //Request contact (like request to be a friend)
  Future<void> sendContactRequest(ContactRequest request) async {
    //get the senderId [_currentUserId]
    //set the senderId to the request
    request = request.copyWith(senderId: _currentUserId);

    final result = await _receiverRequestsCollectionRef(
      request.receiverId,
    ).add(request.toJson());

    await _receiverRequestsCollectionRef(
      request.receiverId,
    ).doc(result.id).update({FirebaseFieldName.id: result.id});
  }

  //if the current user already sent a request
  // to the receiver (other users)
  Stream<bool> isContactRequestSent(String receiverId) async* {
    if (_currentUserId != null) {
      yield* _receiverRequestsCollectionRef(receiverId)
          .where(FirebaseFieldName.senderId, isEqualTo: _currentUserId)
          .snapshots()
          .map((snapshot) => snapshot.docs.isNotEmpty);
    }
  }

  //Cancel sent request
  Future<void> cancelRequest(String receiverId) async {
    final collectionRef = _receiverRequestsCollectionRef(receiverId);
    if (_currentUserId != null) {
      // Query the collection to check if a document
      //with a matching sender ID exists
      QuerySnapshot querySnapshot = await collectionRef
          .where(FirebaseFieldName.senderId, isEqualTo: _currentUserId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a document with a matching sender ID exists, delete it
        await collectionRef.doc(querySnapshot.docs.first.id).delete();
      }
    }
  }

  //if other users (receivers) already sent
  // a request to (me) the current user
  Stream<bool> isContactRequestReceived(String senderId) async* {
    //in this case the current user is the receiver
    // and other users are the sender

    yield* _currentUserRequestsCollectionRef()
        .where(FirebaseFieldName.senderId, isEqualTo: senderId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  //check if specific user (userId) is on
  //(my or in the current user)contact list
  Stream<bool> isUserMyContact(String userId) async* {
    yield* _currentUserContactsCollectionRef()
        .where(FirebaseFieldName.contactId, isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Future<void> _deleteRequest(ContactRequest request) async {
    //deleting the request if the current user accepted
    await _currentUserRequestsCollectionRef().doc(request.id).delete();
  }

  Future<void> removeRequest(ContactRequest request) async {
    await _currentUserRequestsCollectionRef().doc(request.id).delete();
  }

  //request query
  Query<Object?> queryRequests() => _currentUserRequestsCollectionRef().where(
    FirebaseFieldName.receiverId,
    isEqualTo: _currentUserId,
  );

  Stream<int> totalRequests() async* {
    if (_currentUserId != null) {
      yield* _currentUserRequestsCollectionRef()
          .where(FirebaseFieldName.receiverId, isEqualTo: _currentUserId)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    }
  }

  CollectionReference _currentUserRequestsCollectionRef() {
    return _firestore
        .collection(FirebaseCollectionName.users)
        .doc(_currentUserId)
        .collection(FirebaseCollectionName.contactRequests);
  }

  CollectionReference _receiverRequestsCollectionRef(String receiverId) {
    return _firestore
        .collection(FirebaseCollectionName.users)
        .doc(receiverId)
        .collection(FirebaseCollectionName.contactRequests);
  }

  //used to save the contact into current user db
  CollectionReference _currentUserContactsCollectionRef() {
    return _firestore
        .collection(FirebaseCollectionName.users)
        .doc(_currentUserId)
        .collection(FirebaseCollectionName.contacts);
  }

  //used to save the contact into other user db
  CollectionReference _senderUserContactsCollectionRef(String senderId) {
    return _firestore
        .collection(FirebaseCollectionName.users)
        .doc(senderId)
        .collection(FirebaseCollectionName.contacts);
  }
}
