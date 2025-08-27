import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

// Generic FirestorePaginatedWidget to work with values of type T
class PaginatedQueryWidget<T> extends StatelessWidget {
  const PaginatedQueryWidget({
    super.key,
    required this.query,
    required this.builder,
    this.physics,
  });
  final Query<T> query;
  final Widget Function(
    BuildContext context,
    FirestoreQueryBuilderSnapshot<T> snapshot,
  )
  builder;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<T>(
      query: query,
      pageSize: AppConstants.pageSize,
      builder: (ctx, snapshot, _) {
        if (snapshot.isFetching) {
          return const LoadingIndicator();
        }
        if (snapshot.hasError) {
          return DisplayErrorMessage(error: snapshot.error);
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;

            if (metrics.pixels > metrics.maxScrollExtent) {
              //if we reached the end of the screen
              // (in this case top of the screen) fetch more data
              if (snapshot.hasMore) snapshot.fetchMore();
            }
            return true;
          },
          child: builder(context, snapshot),
        );
      },
    );
  }
}
