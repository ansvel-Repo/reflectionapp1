import 'package:flutter/material.dart';

@immutable
class AppAssets {
  const AppAssets._();

  static const ImageProvider logo = AssetImage(
    'assets/convasa/imgs/app_logo.png',
  );
  static const ImageProvider addContact = AssetImage(
    'assets/convasa/imgs/add_contact.png',
  );
  static const ImageProvider noChat = AssetImage(
    'assets/convasa/imgs/no_chat.png',
  );
  static const ImageProvider noMessage = AssetImage(
    'assets/convasa/imgs/no_msg.png',
  );
  static const ImageProvider noNotifications = AssetImage(
    'assets/convasa/imgs/no_notifications.png',
  );
  static const ImageProvider noStories = AssetImage(
    'assets/convasa/imgs/no_stories.png',
  );
  static const ImageProvider resetPassword = AssetImage(
    'assets/convasa/imgs/reset_password.png',
  );
}
