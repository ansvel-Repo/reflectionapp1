import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/features/features.dart';

typedef QueryContacts = List<QueryDocumentSnapshot<Contact>>;
typedef QueryUsers = List<QueryDocumentSnapshot<AppUser>>;
typedef Groups = List<QueryDocumentSnapshot<GroupModel>>;
typedef Requests = List<ContactRequest>;
typedef Messages = List<ChatMessage>;
typedef Contacts = List<Contact>;
typedef Users = List<AppUser>;
typedef Stories = List<Story>;
typedef Chats = List<Chat>;
