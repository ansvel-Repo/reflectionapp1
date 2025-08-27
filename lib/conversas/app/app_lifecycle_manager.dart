//The built in lifecycle management
// does not provide a app-open event,
//but this method we can handle this event.

import 'package:flutter/material.dart';

/// see [AppLifecycleState] but added [opened]
enum AppState {
  opened,
  resumed,
  paused,
  hidden,
  inactive,
  detached,
}

class AppLifecycleManager extends StatefulWidget {
  final Widget child;
  final void Function(AppState state) didChangeAppState;
  const AppLifecycleManager({
    super.key,
    required this.child,
    required this.didChangeAppState,
  });

  @override
  State<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    widget.didChangeAppState(AppState.opened);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppState appState = switch (state) {
      AppLifecycleState.resumed => AppState.resumed,
      AppLifecycleState.inactive => AppState.inactive,
      AppLifecycleState.paused => AppState.paused,
      AppLifecycleState.detached => AppState.detached,
      AppLifecycleState.hidden => AppState.hidden,
    };

    widget.didChangeAppState(appState);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
