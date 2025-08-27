import 'package:ansvel/homeandregistratiodesign/util/common/appbar/appbar.dart';
import 'package:ansvel/homeandregistratiodesign/util/common/widgets/notification/notificationcounter.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/colors.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/text_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class THomeAppBar extends StatefulWidget {
  const THomeAppBar({
    super.key,
    this.color,
    this.textcolor = TColors.grey,
    this.textcolor2 = TColors.white,
    this.text1 = TTexts.homeAppbarTitle,
    this.iconcolor = TColors.white,
  });

  final Color? color;
  final Color? iconcolor;
  final Color? textcolor;
  final Color? textcolor2;
  final String? text1;

  @override
  State<THomeAppBar> createState() => _THomeAppBarState();
}

class _THomeAppBarState extends State<THomeAppBar> {
  String userFullName = TTexts.homeAppbarSubTitle; // Default value
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchUserFullName();
  }

  /// Fetch user full name from Firestore BVN collection
  Future<void> _fetchUserFullName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => userFullName = TTexts.homeAppbarSubTitle);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('BVN')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final firstName = data['first_name'] ?? '';
        final lastName = data['last_name'] ?? '';
        final fullName = "$firstName $lastName".trim();

        setState(() {
          userFullName =
              fullName.isNotEmpty ? fullName : TTexts.homeAppbarSubTitle;
        });
      } else {
        setState(() => userFullName = TTexts.homeAppbarSubTitle);
      }
    } catch (e) {
      setState(() => userFullName = TTexts.homeAppbarSubTitle);
      Get.snackbar("Error", "Failed to fetch user name: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TAppBarCommerce(
      title: Container(
        color: widget.color,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.text1!,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .apply(color: widget.textcolor)),
            SizedBox(
              width: double.infinity,
              child: isLoading
                  ? const CircularProgressIndicator() // Show loading indicator
                  : Text(
                      userFullName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: widget.textcolor2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TNotificationCounterIcon(
          onPressed: () {},
          iconColor: TColors.white,
        )
      ],
    );
  }
}
