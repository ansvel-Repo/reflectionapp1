import 'dart:math';
import 'dart:typed_data';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AppHelpers {
  AppHelpers._();

  //if user has very long name
  //display only the first two names
  static String formatUsername(String username) {
    final parts = username.split(" ");

    //if the user has only a name return it
    if (parts.length == 1) return username.capitalize;

    //if the user has 2 or more names return
    //the first char of first and second name
    if (parts.length >= 2) {
      final firstName = username.split(" ")[0].capitalize;
      final lastName = username.split(" ").last.capitalize;
      return '$firstName $lastName';
    } else {
      return 'N/A';
    }
  }

  //get First Character of the user name
  static String getFirstUsernameChar(String username) {
    final parts = username.split(" ");

    //if the user has only a name return the first char
    if (parts.length == 1) return username[0].capitalize;

    //if the user has 2 or more names return
    //the first char of first and second name
    if (parts.length == 2) {
      final firstName = username.split(" ")[0].capitalize;
      final lastName = username.split(" ")[1].capitalize;
      return '${firstName[0]}${lastName[0]}';
    }
    if (parts.length > 2) {
      final firstName = username.split(" ")[0].capitalize;
      final lastName = username.split(" ")[2].capitalize;
      return '${firstName[0]}${lastName[0]}';
    } else {
      return 'N/A';
    }
  }

  //check if a story expiration date arrives
  static bool isExpirationDateArrived(Timestamp timestamp) {
    //format timestamp
    final String dateStr = formatTimestamp(timestamp);
    // Define the date format used in the input string
    final inputFormat = DateFormat('dd MMM yyyy, hh:mm a');

    // Parse the input date string into a DateTime object
    final inputDate = inputFormat.parse(dateStr);

    // Get the current date and time
    final now = DateTime.now();

    // Compare the input date with the current date
    return inputDate.isBefore(now) || inputDate.isAtSameMomentAs(now);
  }

  //format date
  static String formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp.toDate().toString());
    var format = DateFormat('d MMM yyyy, hh:mm a');
    return format.format(dateTime);
  }

  static String formatMonthYear(Timestamp timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp.toDate().toString());
    var format = DateFormat('MMM yyyy');
    return format.format(dateTime);
  }

  //format message time
  static String formatMessageTime(Timestamp timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp.toDate().toString());
    var format = DateFormat.Hm();
    return format.format(dateTime);
  }

  // Method to calculate the expiration date as a Firebase Timestamp
  static Timestamp calculateStoryExpirationDate() {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the expiration date (current time + 24 hours)
    DateTime expirationTime = currentTime.add(const Duration(hours: 24));

    // Convert the expiration date to a Firebase Timestamp
    Timestamp expirationTimestamp = Timestamp.fromDate(expirationTime);

    return expirationTimestamp;
  }

  //generate unique int for local notification id
  static int generateUniqueId() {
    final random = Random();
    return random.nextInt(1000000);
  }

  //filter contacts based on query input
  //this is used on contacts page
  //new chat & create group page
  static QueryContacts contactsFilteredByQuery({
    required QueryContacts contacts,
    required WidgetRef ref,
    required String query,
  }) {
    // Create a Set to ensure uniqueness
    final Set<QueryDocumentSnapshot<Contact>> uniqueItems =
        <QueryDocumentSnapshot<Contact>>{};

    // Filter the contact based on the query and add them to the Set
    if (query.isNotEmpty) {
      for (var contact in contacts) {
        final user = _getUserFromServer(
          userId: contact.data().contactId,
          ref: ref,
        );

        if (user != null) {
          if (user.username.toLowerCase().contains(query.toLowerCase())) {
            uniqueItems.add(contact);
          }
        }
      }
    }

    // Convert the Set back to a List
    return query.isEmpty ? contacts : uniqueItems.toList();
  }

  //get specific user by passing the id
  static AppUser? _getUserFromServer({
    required String userId,
    required WidgetRef ref,
  }) {
    return ref.watch(getUserByIdProvider(userId)).asData?.value;
  }

  //open url on webview
  static void openUrl(String uri) async {
    final url = Uri.parse(uri);
    try {
      await launchUrl(url);
    } on Exception catch (error) {
      AppAlerts.displaySnackbar(error.toString());
    }
  }

  //save image to gallery
  static Future<bool> downloadImage(String imgUrl) async {
    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(imgUrl));

      // Convert the response body to Uint8List
      final Uint8List image = Uint8List.fromList(response.bodyBytes);

      // Save the image to the gallery
      await ImageGallerySaver.saveImage(
        image,
        quality: 100,
        name: 'conversasApp${DateTime.now()}',
      );

      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  //pick image from gallery
  static Future<void> getImageFromGallery({
    required WidgetRef ref,
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    final image = await _pickImageFromGallery(imageSource);
    if (image != null) {
      ref.read(selectedImageProvider.notifier).state = image;
    }
  }

  static Future<XFile?> _pickImageFromGallery(ImageSource imageSource) async {
    ImageSource.gallery;

    XFile? pickedFile = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 80,
    );
    return pickedFile == null ? null : XFile(pickedFile.path);
  }
}
