import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';

abstract class ContactsRepository {
  Future<Contacts> getAllContacts(Contact? lastContact);
  Future<Contact?> getContactById(String contactId);
  Future<void> updateActiveStatus(bool isOnline);
  Future<void> updateContact(Contact contact);
  Future<void> removeContact(Contact contact);
  Stream<AppUser?> getUserById(String userId);
  Future<void> deleteContact(Contact contact);
  Future<Users> getAllUsers(AppUser? lastUser);
  Stream<bool> isUserExists(String userId);
  Query<Contact> queryContacts();
  Query<AppUser> queryUsers();
}
