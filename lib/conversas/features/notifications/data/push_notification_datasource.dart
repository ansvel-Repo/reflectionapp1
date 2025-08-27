import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationDataSource {
  PushNotificationDataSource._();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _fmc = FirebaseMessaging.instance;

  static String? get _currentUserId => _auth.currentUser?.uid;

  static void subscribeToTopic(String topic) async {
    await _fmc.subscribeToTopic(topic);
  }

  static void unsubscribeFromTopic(String topic) async {
    await _fmc.unsubscribeFromTopic(topic);
  }

  //set user token for push notifications
  static void setUserFcmToken() async {
    if (_currentUserId == null) return;

    final token = await _fmc.getToken();

    if (token == null) return;

    final userCollectionRef = _usersCollectionRef().doc(_currentUserId);

    if (_currentUserId != null) {
      // Query the collection to check if a document
      //with a matching current user ID exists
      final querySnapshot = await userCollectionRef.get();

      if (querySnapshot.exists) {
        // If a document with a matching current user ID exists,
        //save the pushToken
        await userCollectionRef.update({FirebaseFieldName.pushToken: token});
      }
    }
  }

  //delete user token for not receiving push notifications
  static void deleteUserFcmToken() async {
    if (_currentUserId == null) return;

    await Future.wait([
      _fmc.deleteToken(),
      _usersCollectionRef().doc(_currentUserId).update({
        FirebaseFieldName.pushToken: '',
      }),
    ]);
  }

  static CollectionReference _usersCollectionRef() {
    return _firestore.collection(FirebaseCollectionName.users);
  }
}
