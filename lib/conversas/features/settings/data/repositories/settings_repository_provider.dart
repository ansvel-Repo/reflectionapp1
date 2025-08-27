import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final dataSource = ref.read(settingsDatasourceProvider);
  return SettingsRepositoryImpl(dataSource);
});
