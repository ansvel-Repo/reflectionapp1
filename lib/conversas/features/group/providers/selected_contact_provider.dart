import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedContactProvider =
    StateNotifierProvider<SelectedContactNotifier, List<String>>((ref) {
      return SelectedContactNotifier();
    });

class SelectedContactNotifier extends StateNotifier<List<String>> {
  SelectedContactNotifier() : super(const []);

  void addContact(String userId) {
    if (state.length < AppConstants.groupSize) {
      state = [...state, userId];
    }
  }

  void addAll(List<String> ids) {
    if (state.length < AppConstants.groupSize) {
      state = ids;
    }
  }

  void removeContact(String userId) {
    state = state.where((c) => c != userId).toList();
  }

  void reset() => state = [];
}
