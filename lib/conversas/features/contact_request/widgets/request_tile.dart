import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';

class RequestTile extends ConsumerWidget {
  const RequestTile({super.key, required this.request});
  final ContactRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    final userAsyncValue = ref.watch(getUserByIdProvider(request.senderId));
    final l10n = context.l10n;

    return AsyncValueWidget<AppUser>(
      value: userAsyncValue,
      data: (user) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DisplayProfileImg(imageUrl: user.imageUrl, username: user.username),
            AppSpaces.hMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: DisplayUsername(user: user)),
                      const Spacer(),
                      DisplayTimeAgo(time: request.createdAt),
                    ],
                  ),
                  Text(l10n.sentYouContactRequest),
                  AppSpaces.vSmall,
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _acceptRequest(ref),
                        child: isLoading
                            ? const LoadingIndicator()
                            : Text(l10n.confirm),
                      ),
                      AppSpaces.hMedium,
                      CommonOutlinedButton(
                        onPressed: () => _removeRequest(ref),
                        child: Text(l10n.remove),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _acceptRequest(WidgetRef ref) async {
    await ref
        .read(addUserToContactsProvider(request).future)
        .then((value) {
          return;
        })
        .catchError((error) {
          AppAlerts.displaySnackbar('$error');
          return;
        });
  }

  void _removeRequest(WidgetRef ref) async {
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
}
