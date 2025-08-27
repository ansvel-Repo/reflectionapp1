import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';

final subscribeNotificationProvider =
    StateNotifierProvider<SubscribeNotificationNotifier, bool>((ref) {
      final prefs = SharedPrefs.instance;
      return SubscribeNotificationNotifier(prefs);
    });
