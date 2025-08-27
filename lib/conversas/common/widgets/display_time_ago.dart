import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayTimeAgo extends StatelessWidget {
  const DisplayTimeAgo({Key? key, required this.time}) : super(key: key);
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Text(
      _getTimeAgo(),
      style: context.textStyle.labelMedium,
      textAlign: TextAlign.center,
    );
  }

  String _getTimeAgo() {
    final DateTime date = DateTime.parse(time.toDate().toString());
    return timeago.format(date, locale: 'en_short');
  }
}
