import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

// Generic PaginatedListWidget to work with values of type T
class PaginatedListWidget<T> extends StatelessWidget {
  const PaginatedListWidget({
    super.key,
    required this.query,
    required this.msg,
    required this.image,
    required this.itemBuilder,
    this.controller,
    this.physics,
    this.reverse = false,
  });
  final Query<T> query;
  final String msg;
  final ImageProvider image;
  final ScrollController? controller;
  final bool reverse;
  // output builder function
  final Widget Function(BuildContext, QueryDocumentSnapshot<T>) itemBuilder;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<T>(
      query: query,
      shrinkWrap: true,
      pageSize: AppConstants.pageSize,
      controller: controller,
      reverse: reverse,
      physics: physics,
      errorBuilder: (ctx, error, _) => DisplayErrorMessage(error: error),
      loadingBuilder: (context) => const LoadingIndicator(),
      emptyBuilder: (context) {
        return DisplayEmptyListMsg(msg: msg, image: image);
      },
      itemBuilder: itemBuilder,
    );
  }
}
