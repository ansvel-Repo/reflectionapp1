import 'package:ansvel/conversas/app/app.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class UserActiveStatus {
  const UserActiveStatus._();
  //updating user active status
  //based on app lifecycle events
  //resume -- active or online
  //pause  -- inactive or offline
  static void setUserStatus(WidgetRef ref) async {
    final currentUserId = ref.read(currentUserIdProvider);

    if (currentUserId != null) {
      SystemChannels.lifecycle.setMessageHandler((message) {
        if (message != null) {
          if (message.contains(AppState.resumed.name)) {
            _setUserOnline(ref);
          }
          if (message.contains(AppState.inactive.name)) {
            _setUserOffline(ref);
          }

          if (message.contains(AppState.paused.name)) {
            _setUserOffline(ref);
          }

          if (message.contains(AppState.hidden.name)) {
            _setUserOffline(ref);
          }

          if (message.contains(AppState.detached.name)) {
            _setUserOffline(ref);
          }
        }
        return Future.value(message);
      });
    }
  }

  static void _setUserOnline(WidgetRef ref) async {
    await ref.read(updateActiveStatusProvider(true).future);
  }

  static void _setUserOffline(WidgetRef ref) async {
    await ref.read(updateActiveStatusProvider(false).future);
  }
}
