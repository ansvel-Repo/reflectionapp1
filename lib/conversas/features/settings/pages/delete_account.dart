import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';

class DeleteAccountPage extends ConsumerStatefulWidget {
  static DeleteAccountPage builder(BuildContext context, GoRouterState state) =>
      const DeleteAccountPage();
  const DeleteAccountPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<DeleteAccountPage> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(title: l10n.deleteAccount),
      body: SingleChildScrollView(
        padding: AppPaddings.allLarge,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.deleteAccountQuestion),
            AppSpaces.vMedium,
            Text(l10n.ifDeleteAccount),
            AppSpaces.vSmaller,
            Text(l10n.deleteAccountAlter1),
            AppSpaces.vSmaller,
            Text(l10n.deleteAccountAlter2),
            AppSpaces.vSmaller,
            Text(l10n.deleteAccountAlter3),
            AppSpaces.vSmaller,
            Text(l10n.deleteAccountAlter4),
            AppSpaces.vSmaller,
            Text(l10n.cantBeUndoneDeleteAccount),
            Row(
              children: [
                Checkbox.adaptive(
                  value: _isAccepted,
                  activeColor: context.colorScheme.primary,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _isAccepted = value;
                      });
                    }
                  },
                ),
                Text(l10n.iWantDeleteMyAccount),
              ],
            ),
            Text(l10n.deleteAccountLastAlert),
            AppSpaces.vLarge,
            isLoading
                ? const LoadingIndicator()
                : ElevatedButton(
                    onPressed: _isAccepted ? _dialogToReAuthenticateUser : null,
                    child: Text(l10n.deleteAccount),
                  ),
            AppSpaces.vMedium,
            CommonOutlinedButton(
              onPressed: () => context.pop(),
              child: Text(l10n.cancel, style: context.textStyle.titleMedium),
            ),
          ],
        ),
      ),
    );
  }

  void _dialogToReAuthenticateUser() async {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const PasswordDialog();
        },
      );
    }
  }

  void _deleteAccount() async {
    final l10n = context.l10n;
    ref.read(isLoadingProvider.notifier).state = true;

    await ref
        .read(deleteAccountProvider.future)
        .then((value) {
          ref.read(isLoadingProvider.notifier).state = false;
          if (context.mounted) context.go(RouteLocation.login);
        })
        .catchError((_) {
          ref.read(isLoadingProvider.notifier).state = false;
          AppAlerts.displaySnackbar(l10n.somethingWentWrong);
        });
  }
}
