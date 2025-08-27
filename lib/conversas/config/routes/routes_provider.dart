import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final navigationKey = GlobalKey<NavigatorState>();

final routesProvider = Provider.autoDispose<GoRouter>((ref) {
  final splashTimerState = ref.watch(splashTimerProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  final redirection = isLoggedIn ? RouteLocation.contacts : RouteLocation.login;

  if (splashTimerState != SplashTimerState.completed) {
    return GoRouter(
      initialLocation: RouteLocation.splash,
      navigatorKey: navigationKey,
      routes: appRoutes,
      errorBuilder: ErrorPage.builder,
    );
  }

  return GoRouter(
    initialLocation: redirection,
    navigatorKey: navigationKey,
    routes: appRoutes,
    errorBuilder: ErrorPage.builder,
  );
});
