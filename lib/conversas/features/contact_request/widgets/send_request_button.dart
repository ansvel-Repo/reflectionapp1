import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SendRequestButton extends ConsumerWidget {
  const SendRequestButton({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final textStyle = context.textStyle.labelSmall?.copyWith(
      color: colors.primary,
    );

    final isMyContact =
        ref.watch(isUserMyContactProvider(user.userId)).asData?.value ?? false;
    final requestSentAsyncValue = ref.watch(
      isContactRequestSentProvider(user.userId),
    );
    final requestReceivedAsyncValue = ref.watch(
      isContactRequestReceivedProvider(user.userId),
    );
    return AsyncValueWidget<bool>(
      value: requestSentAsyncValue,
      data: (isRequestSent) {
        return AsyncValueWidget<bool>(
          value: requestReceivedAsyncValue,
          data: (isRequestReceived) {
            //if the current user do not send or received a request from
            //the passed to this widget
            return isMyContact
                ? CommonOutlinedButton(
                    onPressed: () {
                      context.pushNamed(
                        RouteLocation.personalChat,
                        pathParameters: {AppKeys.receiverId: user.userId},
                      );
                    },
                    child: Text(
                      l10n.message,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  )
                : isRequestSent
                ? CommonOutlinedButton(
                    onPressed: () => _cancelRequest(ref),
                    child: Text(
                      l10n.requestSent,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  )
                : isRequestReceived
                ? CommonOutlinedButton(
                    child: Text(
                      RequestStatus.pending.name.capitalize,
                      style: textStyle,
                    ),
                  )
                : ElevatedButton(
                    onPressed: () =>
                        _sendContactRequest(context: context, ref: ref),
                    child: Text(l10n.add),
                  );
          },
        );
      },
    );
  }

  void _sendContactRequest({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final l10n = context.l10n;
    //fetch current user
    final currentUserId = ref.watch(currentUserIdProvider);
    if (currentUserId != null) {
      final currentUser = await ref.watch(
        getUserByIdProvider(currentUserId).future,
      );

      final request = ContactRequest(
        id: '',
        senderId: '',
        receiverId: user.userId,
        status: RequestStatus.pending,
        createdAt: Timestamp.now(),
      );
      await ref.read(requestContactProvider(request).future).then((
        value,
      ) async {
        await NotificationService.sendPushNotification(
          msg: l10n.sentYouContactRequest,
          receiverToken: user.pushToken,
          sender: currentUser,
          type: AppKeys.request,
        );
      });
    }
  }

  void _cancelRequest(WidgetRef ref) async {
    await ref.read(cancelRequestProvider(user.userId).future);
  }
}
