import 'package:flutter/material.dart';
import 'package:ansvel/conversas/app/app_lifecycle_manager.dart';
import 'package:ansvel/conversas/app/conversas_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';

class ConversasEntry extends StatelessWidget {
  const ConversasEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLifecycleManager(
      didChangeAppState: (state) {
        // Optional: Add any Convasa-specific lifecycle logic here if needed
        // If you need to access Riverpod providers, use:
        final container = ProviderScope.containerOf(context);
        if (state == AppState.opened) {
          //for updating user active status when the app is opened
          //only for authenticated users
          //non authenticated users
          //is set online when login
          container.read(updateActiveStatusProvider(true));

          //cache current user id locally
          final userId = container.read(currentUserIdProvider);
          LocalCache.cacheCurrentUserId(id: userId);
        }
      },
      child: const ConversasApp(),
    );
  }
}
