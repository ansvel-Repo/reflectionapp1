import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> recordTransaction({
    required String narration,
    required String transactionType, // 'Credit' or 'Debit'
    required double amount,
    required String recipient,
    bool includeTransactionId = true,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final transactionData = {
      'Narration': narration,
      'Transaction_Type': transactionType,
      'Amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
      'Recipient': recipient,
      'UserID': user.uid,
      'formattedDate': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      'formattedTime': DateFormat('hh:mm a').format(DateTime.now()),
    };

    if (includeTransactionId) {
      final transactionRef = _firestore.collection('transactionhistory').doc();
      transactionData['transactionId'] = transactionRef.id;
      await transactionRef.set(transactionData);
    } else {
      await _firestore.collection('transactionhistory').add(transactionData);
    }
  }

  Future<void> recordTransactionWithBatch({
    required String narration,
    required String transactionType,
    required double amount,
    required String recipient,
    required WriteBatch batch,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final transactionRef = _firestore.collection('transactionhistory').doc();
    
    batch.set(transactionRef, {
      'Narration': narration,
      'Transaction_Type': transactionType,
      'Amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
      'Recipient': recipient,
      'UserID': user.uid,
      'formattedDate': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      'formattedTime': DateFormat('hh:mm a').format(DateTime.now()),
      'transactionId': transactionRef.id,
    });
  }
}