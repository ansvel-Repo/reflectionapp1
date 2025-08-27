import 'package:ansvel/homeandregistratiodesign/views/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComingSoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/commingsoon.jpg'), // Add your image to the assets folder
                  fit: BoxFit.fitWidth, // Cover the entire screen
                ),
              ),
            ),

            // Text Positioned 200px Above the Bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 200, // 200px above the bottom
              child: Text(
                'We’re working hard to bring you an amazing experience.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[900], // Dark grey text for contrast
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Floating Button Positioned 100px Above the Bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 100, // 100px above the bottom
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(
                          () => BottomNavWithAnimatedIcons()); // Navigate back to Dashboard
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.deepPurple[400], // Dark blue button
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const StadiumBorder(),
                      elevation: 8,
                      shadowColor: Colors.black87,
                    ),
                    child: Text(
                      'Go to Dashboard',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold // White text for contrast
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
