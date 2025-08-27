import 'dart:developer';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

class DisplayErrorMessage extends StatelessWidget {
  const DisplayErrorMessage({Key? key, this.error}) : super(key: key);
  final Object? error;

  @override
  Widget build(BuildContext context) {
    log('$error');
    return Center(child: Text('${context.l10n.somethingWentWrong}\n$error'));
  }
}
