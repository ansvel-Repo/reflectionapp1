import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactsDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  ContactsDataSource(this._firestore, this._auth);

  String? get _currentUserId => _auth.currentUser?.uid;

  Stream<QuerySnapshot<Object?>> getUserById(String userId) async* {
    yield* _usersCollectionRef()
        .where(FieldPath.documentId, isEqualTo: userId)
        .limit(1)
        .snapshots();
  }

  Future<QuerySnapshot<Object?>?> getContactById(String contactId) async {
    if (_currentUserId == null) return null;
    return _contactsCollectionRef(
      '$_currentUserId',
    ).where(FirebaseFieldName.contactId, isEqualTo: contactId).limit(1).get();
  }

  Future<QuerySnapshot<Object?>?> getAllUsers(AppUser? lastUser) async {
    //get all users. except the current one

    if (_currentUserId == null) return null;

    final usersRef = _usersCollectionRef()
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        .limit(AppConstants.pageSize);

    return lastUser == null
        ? usersRef.get()
        : usersRef.startAfter([lastUser.createdAt]).get();
  }

  Future<void> updateContact(Contact contact) async {
    if (_currentUserId != null) {
      await _contactsCollectionRef(
        '$_currentUserId',
      ).doc(contact.id).update(contact.toJson());
    }
  }

  Future<void> removeContact(Contact contact) async {
    if (_currentUserId != null) {
      await Future.wait([
        //delete on my contact list
        _contactsCollectionRef('$_currentUserId').doc(contact.id).delete(),
        //delete on contact list of the
        //user i'm removing from my contacts
        _contactsCollectionRef(contact.contactId).doc(contact.id).delete(),
      ]);
    }
  }

  Future<QuerySnapshot<Object?>?> getAllContacts(Contact? lastContact) async {
    if (_currentUserId == null) return null;

    final contactsRef = _contactsCollectionRef('$_currentUserId')
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        .limit(AppConstants.pageSize);

    return lastContact == null
        ? contactsRef.get()
        : contactsRef.startAfter([lastContact.createdAt]).get();
  }

  // update online or last active status of user
  Future<void> updateActiveStatus(bool isOnline) async {
    if (_currentUserId != null) {
      _usersCollectionRef().doc(_currentUserId).update({
        FirebaseFieldName.isOnline: isOnline,
        FirebaseFieldName.lastActive: Timestamp.now(),
      });
    }
  }

  Stream<bool> isUserExists(String userId) async* {
    // Check if a user document with the
    //given userId exists in the users collection
    yield* _usersCollectionRef()
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  Future<void> deleteContact(Contact contact) async {
    if (_currentUserId != null) {
      //delete contact from the current user list
      //if the contactId delete his account
      await _contactsCollectionRef('$_currentUserId').doc(contact.id).delete();
    }
  }

  //contacts query
  Query<Object?> queryContacts() => _contactsCollectionRef(
    '$_currentUserId',
  ).orderBy(FirebaseFieldName.createdAt, descending: true);

  //contacts query
  Query<Object?> queryUsers() => _usersCollectionRef().where(
    FieldPath.documentId,
    isNotEqualTo: '$_currentUserId',
  );

  CollectionReference _usersCollectionRef() {
    return _firestore.collection(FirebaseCollectionName.users);
  }

  CollectionReference _contactsCollectionRef(String userId) {
    return _firestore
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.contacts);
  }
}
