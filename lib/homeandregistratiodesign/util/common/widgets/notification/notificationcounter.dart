import 'package:ansvel/homeandregistratiodesign/util/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TNotificationCounterIcon extends StatefulWidget {
  const TNotificationCounterIcon({
    super.key,
    required this.onPressed,
    required this.iconColor,
  });

  final VoidCallback onPressed;
  final Color iconColor;

  @override
  State<TNotificationCounterIcon> createState() =>
      _TNotificationCounterIconState();
}

class _TNotificationCounterIconState extends State<TNotificationCounterIcon> {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUnreadCount();
  }

  Future<void> _fetchUnreadCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Notifications')
        .where('isRead', isEqualTo: false)
        .get();

    setState(() {
      _unreadCount = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            widget.onPressed();
            _fetchUnreadCount(); // Refresh count when pressed
          },
          icon: Icon(Iconsax.notification, color: widget.iconColor),
        ),
        if (_unreadCount > 0)
          Positioned(
            top: 2,
            right: 9,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: TColors.error, // Use error color for attention
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  _unreadCount.toString(),
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                        color: TColors.white,
                        fontSizeFactor: 0.8,
                      ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
