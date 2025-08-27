import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Generic AsyncValueWidget to work with values of type T
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({super.key, required this.value, required this.data});
  // input async value
  final AsyncValue<T> value;
  // output builder function
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (error, _) => DisplayErrorMessage(error: error),
      loading: () => const LoadingIndicator(),
    );
  }
}
