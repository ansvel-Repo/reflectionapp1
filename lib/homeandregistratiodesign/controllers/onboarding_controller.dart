import 'package:ansvel/homeandregistratiodesign/models/onboarding_data.dart';
// import 'package:ansvel/models/onboarding_data.dart';
import 'package:flutter/material.dart';


class OnboardingController extends ChangeNotifier {
  OnboardingData _data = OnboardingData();
  OnboardingData get data => _data;

  void updateData(OnboardingData updatedData) {
    _data = updatedData;
    notifyListeners();
  }

  void updateField({
    String? nin,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? phoneNumber,
    String? gender,
    String? bvn,
    String? address,
  }) {
    _data = OnboardingData(
      nin: nin ?? _data.nin,
      firstName: firstName ?? _data.firstName,
      lastName: lastName ?? _data.lastName,
      dateOfBirth: dateOfBirth ?? _data.dateOfBirth,
      phoneNumber: phoneNumber ?? _data.phoneNumber,
      gender: gender ?? _data.gender,
      bvn: bvn ?? _data.bvn,
      address: address ?? _data.address,
    );
    notifyListeners();
  }

  void clearData() {
    _data = OnboardingData();
    notifyListeners();
  }
}