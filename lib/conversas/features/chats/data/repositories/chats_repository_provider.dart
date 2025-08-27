import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatsRepositoryProvider = Provider<ChatsRepository>((ref) {
  final dataSource = ref.read(chatsDatasourceProvider);
  return ChatsRepositoryImpl(dataSource);
});
