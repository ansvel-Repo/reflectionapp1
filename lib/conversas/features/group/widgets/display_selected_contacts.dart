import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplaySelectedContacts extends ConsumerWidget {
  const DisplaySelectedContacts({super.key, this.isGroupInfo = false});
  final bool isGroupInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContacts = ref.watch(selectedContactProvider);
    final totalSelected = selectedContacts.length;
    const limit = AppConstants.groupSize;
    final l10n = context.l10n;
    final displayText = isGroupInfo
        ? '${l10n.participants} $totalSelected ${l10n.oF} $limit'
        : '${l10n.addParticipants} ($totalSelected/$limit)';

    return selectedContacts.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpaces.vMedium,
              Text(
                displayText,
                style: context.textStyle.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpaces.vSmall,
              CustomContainer(
                height: AppSizes.extraLarge,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    final userId = selectedContacts[index];

                    return SelectedContactTile(userId: userId);
                  },
                  separatorBuilder: (ctx, index) => AppSpaces.hSmallest,
                  itemCount: selectedContacts.length,
                ),
              ),
            ],
          );
  }
}
