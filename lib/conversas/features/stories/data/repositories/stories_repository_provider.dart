import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storiesRepositoryProvider = Provider<StoriesRepository>((ref) {
  final datasource = ref.read(storiesDatasourceProvider);
  return StoriesRepositoryImpl(datasource);
});
