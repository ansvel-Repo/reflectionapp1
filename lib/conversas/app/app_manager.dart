import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppManager {
  const AppManager();

  static Future<void> initializeDependencies() async {
    await Future.wait([
      //init firebase
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      //init shared prefs
      SharedPrefs.init(),

      //get all app info version and so on ..
      AppPackageInfo.init(),

      //wait for window size to be initialized
      ScreenUtil.ensureScreenSize(),

      //get fcm keys
      dotenv.load(fileName: "secrete_keys.env"),
    ]);

    //Register error handlers.
    //display a nice ui to the
    //user instead of a red screen
    _registerErrorHandlers();

    _setUpDeviceOrientation();
  }

  //Device orientation
  static void _setUpDeviceOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void _registerErrorHandlers() {
    // Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint(details.toString());
    };

    //Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      debugPrint(error.toString());
      return true;
    };

    //Show some error UI when any widget in the app fails to build
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(
          child: Padding(
            padding: AppPaddings.allLarge,
            child: Text(details.toString()),
          ),
        ),
      );
    };
  }
}
