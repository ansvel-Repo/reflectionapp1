// import 'package:ansvel_lifestyle/authenticate/src/features/core/screens/dashboard/dashboard.dart';
// import 'package:ansvel_lifestyle/authenticate/src/features/core/screens/homenotification/homenotification.dart';
// import 'package:ansvel_lifestyle/authenticate/src/features/core/screens/profile/profile_screen.dart';
// import 'package:ansvel_lifestyle/authenticate/src/features/core/screens/searchpage/homesearchpage.dart';
// import 'package:ansvel_lifestyle/authenticate/src/features/core/screens/settings/settings.dart';
// import 'package:ansvel_lifestyle/custombottomnavigation/models/nav_item_model.dart';

import 'package:ansvel/homeandregistratiodesign/views/home_page.dart';
import 'package:ansvel/homeandregistratiodesign/views/homenotification/homenotification.dart';

import 'package:ansvel/homeandregistratiodesign/views/searchpage/homesearchpage.dart';
import 'package:ansvel/homeandregistratiodesign/views/settings/settings.dart';
import 'package:ansvel/loginapp/src/features/core/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:ansvel/homeandregistratiodesign/views/custombottomnavigation/models/nav_item_model.dart';




import 'package:rive/rive.dart';

const Color bottomNavBgColor = Color(0xFF17203A);

class BottomNavWithAnimatedIcons extends StatefulWidget {
  const BottomNavWithAnimatedIcons({super.key});

  @override
  State<BottomNavWithAnimatedIcons> createState() =>
      _BottomNavWithAnimatedIconsState();
}

class _BottomNavWithAnimatedIconsState
    extends State<BottomNavWithAnimatedIcons> {
  List<SMIBool> riveIconInputs2 = [];
  List<StateMachineController?> controllers2 = [];
  int selectedNavIndex2 = 0;
  int Index = 0;

  // List of pages
  final List<Widget> _pages = [
   // const Dashboard(),
   const HomePage(),
    SearchPage(),
    const HomePage(), // replace with chat page
    NotificationPage(),
    ProfileScreen(),
    SettingsPage(),
  ];

  void animateTheIcon(int index) {
    if (index >= 0 && index < riveIconInputs2.length) {
      riveIconInputs2[index].change(true);
      Future.delayed(const Duration(seconds: 1), () {
        riveIconInputs2[index].change(false);
      });
    }
  }

  void riveOnInIt(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);
    if (controller != null) {
      artboard.addController(controller);
      controllers2.add(controller);
      riveIconInputs2.add(controller.findInput<bool>("active") as SMIBool);
    }
  }

  @override
  void dispose() {
    for (var controller in controllers2) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedNavIndex2],
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: bottomNavBgColor.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: bottomNavBgColor.withOpacity(0.3),
                offset: const Offset(0, 20),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              buttomNavItems2.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    if (index >= 0 && index < riveIconInputs2.length) {
                      animateTheIcon(index);
                    }
                    setState(() {
                      selectedNavIndex2 = index;
                    });
                    print('SELECTED NAV INDEX: $selectedNavIndex2');
                    print('INDEX AFTER SELECTED: $index');
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBar(isActive: selectedNavIndex2 == index),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: Opacity(
                          opacity: selectedNavIndex2 == index ? 1 : 0.5,
                          child: RiveAnimation.asset(
                            buttomNavItems2[index].rive.src,
                            artboard: buttomNavItems2[index].rive.artboard,
                            onInit: (artboard) {
                              riveOnInIt(
                                artboard,
                                stateMachineName: buttomNavItems2[index]
                                    .rive
                                    .stateMachineName,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({super.key, required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: const BoxDecoration(
        color: Color(0xFF81B4FF),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
