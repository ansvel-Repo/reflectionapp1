
import UIKit
import Flutter
import GoogleMaps
import UserNotifications // Required for notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyD6-u2W-4nuDACffeOjiqsGUyFtZooiPrA") // Replace with your actual key
    GeneratedPluginRegistrant.register(with: self)

    // --- FIX: This code is added to handle foreground notifications on iOS ---
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}