import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const kMinSplashDelay = Duration(seconds: 2);

final splashTimerProvider = StateNotifierProvider((ref) => SplashTimer());

enum SplashTimerState {
  active,
  completed,
}

class SplashTimer extends StateNotifier<SplashTimerState> {
  SplashTimer() : super(SplashTimerState.active);

  void start() {
    Timer(kMinSplashDelay, _onCompleted);
  }

  void _onCompleted() {
    state = SplashTimerState.completed;
  }
}
