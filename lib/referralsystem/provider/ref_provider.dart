import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ansvel/referralsystem/enums/state.dart';

class RefProvider extends ChangeNotifier {
  ViewState state = ViewState.Idle;

  String message = "";

  CollectionReference profileRef =
      FirebaseFirestore.instance.collection("Users");

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> getUserBVN(String userId) async {
    try {
      // Fetch the user's document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        // Return the BVN field from the user's document
        return userDoc.data()!['bvn'] as String?;
      } else {
        // Return null if BVN or user document does not exist
        return null;
      }
    } catch (e) {
      // Handle errors like network issues or insufficient permissions
      debugPrint('Error retrieving BVN: $e');
      return null;
    }
  }

  setReferral(String refCode) async {
    state = ViewState.Busy;
    notifyListeners();

    try {
      final value = await profileRef.where("refCode", isEqualTo: refCode).get();

      // if (value.docs.isEmpty) {
      //   ///ref code is not available
      //   message = 'Refcode is not available';
      //   state = ViewState.Error;
      //   notifyListeners();
      // }
      //
      //else {
      //   /// It exists
      //   final data = value.docs[0];

      //   ///Get referrals
      //   List referrals = data.get("referals");

      //   referrals.add(auth.currentUser!.email);

      //   ///Update the ref earning
      //   final body = {
      //     "referals": referrals,
      //     "refEarnings": data.get("refEarnings") + data.get("referralAmount")
      //   };

      //   await profileRef.doc(data.id).update(body);

      //   message = "Ref success";
      //   state = ViewState.Success;
      //   notifyListeners();
      // }

      if (value.docs.isEmpty) {
        // Referral code is invalid
        message = 'Referral code does not exist in our database';
        state = ViewState.Error;
        notifyListeners();
      } else {
        // Referral code is valid
        final data = value.docs[0];

        // Fetch the current user's BVN
        final userBVN = await getUserBVN(auth.currentUser!.uid);

        if (userBVN == null) {
          // BVN not found for the current user
          message = 'BVN not found for the current user';
          state = ViewState.Error;
          notifyListeners();
          return;
        }

        // Get the current list of referrals
        List referrals = data.get("referals");

        // Check if the BVN is already referred
        bool isBVNAlreadyReferred =
            referrals.any((referral) => referral["bvn"] == userBVN);

        if (!isBVNAlreadyReferred) {
          // Append the current user's BVN and email to the referrals list
          referrals.add({
            "email": auth.currentUser!.email,
            "bvn": userBVN,
          });

          // Update Firestore with the new data
          final updatedData = {
            "referals": referrals,
            //"refEarnings": data.get("refEarnings") + data.get("referralAmount"),
            "refEarnings": referrals.length * data.get("referralAmount"),
          };

          await profileRef.doc(data.id).update(updatedData);

          // Notify the user of success
          message = 'Referral successful!';
          state = ViewState.Success;
          notifyListeners();
        } else {
          // BVN already referred
          message = 'This BVN has already been referred.';
          state = ViewState.Error;
          notifyListeners();
        }
      }
    } on FirebaseException catch (e) {
      message = e.message.toString();
      state = ViewState.Error;
      notifyListeners();
    }
  }
}
