import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class PasswordDialog extends ConsumerStatefulWidget {
  const PasswordDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends ConsumerState<PasswordDialog>
    with Validators {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      child: AlertDialog.adaptive(
        title: Text(l10n.deleteAccount),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(
                controller: _passwordController,
                hintText: l10n.password,
                obscureText: true,
                maxLines: 1,
                validator: (value) => isEmpty(value, l10n.thisFieldIsRequired),
              ),
              AppSpaces.vMedium,
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _reAuthenticate,
            child: isLoading
                ? const LoadingIndicator()
                : Text(l10n.deleteAccount),
          ),
          TextButton(onPressed: () => context.pop(), child: Text(l10n.cancel)),
        ],
      ),
    );
  }

  void _reAuthenticate() async {
    final password = _passwordController.text.trim();
    final bool isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      ref.read(isLoadingProvider.notifier).state = true;
      _formKey.currentState?.save();

      await ref
          .read(reAuthenticateProvider(password).future)
          .then((value) {
            ref.read(isLoadingProvider.notifier).state = false;
            _deleteAccount();
          })
          .catchError((error) {
            AppAlerts.displaySnackbar('$error');
            ref.read(isLoadingProvider.notifier).state = false;
            if (context.mounted) context.pop();
          });
    }
  }

  void _deleteAccount() async {
    await ref
        .read(deleteAccountProvider.future)
        .then((value) {
          if (context.mounted) context.go(RouteLocation.login);
        })
        .catchError((error) {
          AppAlerts.displaySnackbar('$error');
        });
  }
}
