import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscribeNotificationNotifier extends StateNotifier<bool> {
  SubscribeNotificationNotifier(this._prefs) : super(true) {
    _initNotificationSubscription();
  }

  final SharedPreferences _prefs;

  void _initNotificationSubscription() {
    state = _prefs.getBool(AppKeys.subscribing) ?? true;
  }

  void allNotifications(bool isSubscribing) async {
    state = isSubscribing;
    await _prefs.setBool(AppKeys.subscribing, isSubscribing);
  }
}
