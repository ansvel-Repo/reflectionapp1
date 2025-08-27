import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NotificationPage extends ConsumerWidget {
  static NotificationPage builder(BuildContext context, GoRouterState state) =>
      const NotificationPage();
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsQuery = ref.watch(queryRequestsProvider);

    return Scaffold(
      appBar: CommonAppBar(title: context.l10n.notifications),
      body: Padding(
        padding: AppPaddings.allMedium,
        child: Column(
          children: [
            // const DisplayBannerAd(),
            // AppSpaces.vMedium,
            Expanded(
              child: PaginatedListWidget<ContactRequest>(
                query: requestsQuery,
                msg: context.l10n.noRequest,
                image: AppAssets.noNotifications,
                itemBuilder: (ctx, doc) {
                  final request = _getValidRequest(
                    ref: ref,
                    request: doc.data(),
                  );

                  return request == null
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            RequestTile(
                              key: Key(request.id),
                              request: request,
                            ).animate().fadeIn(),
                            const Divider(),
                          ],
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ContactRequest? _getValidRequest({
    required WidgetRef ref,
    required ContactRequest request,
  }) {
    final userId = request.senderId;
    final isUserExits = _isUserExists(ref: ref, userId: userId);
    if (isUserExits) {
      return request;
    } else {
      _removeRequest(ref: ref, request: request);
      return null;
    }
  }

  void _removeRequest({
    required WidgetRef ref,
    required ContactRequest request,
  }) async {
    await ref
        .read(removeRequestProvider(request).future)
        .then((value) {
          return;
        })
        .catchError((error) {
          AppAlerts.displaySnackbar('$error');
          return;
        });
  }

  //check if the chat participant exists
  bool _isUserExists({required WidgetRef ref, required String userId}) {
    return ref.watch(isUserExistsProvider(userId)).asData?.value ?? true;
  }
}
