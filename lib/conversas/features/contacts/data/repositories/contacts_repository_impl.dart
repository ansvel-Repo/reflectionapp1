import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsDataSource _datasource;
  ContactsRepositoryImpl(this._datasource);

  @override
  Future<Users> getAllUsers(AppUser? lastUser) async {
    try {
      final result = await _datasource.getAllUsers(lastUser);
      if (result == null) return [];

      return result.docs.map((doc) {
        return AppUser.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Stream<AppUser?> getUserById(String userId) async* {
    try {
      final result = _datasource.getUserById(userId);
      yield* result.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          return AppUser.fromJson(doc.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<Contacts> getAllContacts(Contact? lastContact) async {
    try {
      final result = await _datasource.getAllContacts(lastContact);
      if (result == null) return [];

      return result.docs
          .map((doc) => Contact.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> removeContact(Contact contact) async {
    try {
      await _datasource.removeContact(contact);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> updateContact(Contact contact) async {
    try {
      await _datasource.updateContact(contact);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> updateActiveStatus(bool isOnline) async {
    try {
      await _datasource.updateActiveStatus(isOnline);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Stream<bool> isUserExists(String userId) async* {
    try {
      yield* _datasource.isUserExists(userId);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> deleteContact(Contact contact) async {
    try {
      return await _datasource.deleteContact(contact);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<Contact?> getContactById(String contactId) async {
    try {
      final result = await _datasource.getContactById(contactId);
      if (result == null) return null;
      if (result.docs.isEmpty) return null;
      final contact = result.docs.first;
      return Contact.fromJson(contact.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Query<Contact> queryContacts() {
    try {
      return _datasource.queryContacts().withConverter(
        fromFirestore: (snapshot, _) =>
            Contact.fromJson(snapshot.data() as Map<String, dynamic>),
        toFirestore: (contact, _) => contact.toJson(),
      );
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Query<AppUser> queryUsers() {
    try {
      return _datasource.queryUsers().withConverter(
        fromFirestore: (snapshot, _) =>
            AppUser.fromJson(snapshot.data() as Map<String, dynamic>),
        toFirestore: (user, _) => user.toJson(),
      );
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }
}
