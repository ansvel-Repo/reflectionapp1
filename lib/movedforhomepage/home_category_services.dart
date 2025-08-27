// // import 'package:ansvel/loginapp/ecommerceappcode/utils/common/widgets/image_text_widget/vertical_image_text.dart';
// // import 'package:ansvel/loginapp/ecommerceappcode/utils/constants/image_strings.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/image_text_widget/vertical_image_text.dart';
// import 'package:flutter/material.dart';

// class HomeCategoryServices extends StatelessWidget {
//   final List<String>? itemName;
//   final List<IconData>? icons;
//   final List<void Function()>? onTap;

//   HomeCategoryServices({
//     super.key,
//     this.itemName,
//     this.onTap,
//     this.icons,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Check if lists are null or empty
//     if (itemName == null || itemName!.isEmpty) {
//       return const SizedBox
//           .shrink(); // Return an empty widget if no items are provided
//     }

//     return SizedBox(
//       height: 110,
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: itemName!.length,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (_, index) {
//           // Ensure the index is within bounds for all lists
//           final icon = icons != null && index < icons!.length
//               ? icons![index]
//               : Icons.error; // Fallback icon
//           final title = itemName![index];
//           final tapCallback = onTap != null && index < onTap!.length
//               ? onTap![index]
//               : () {}; // Fallback empty function

//           return TVerticalImageText(
//             icon: icon,
//             title: title,
//             onTap: tapCallback,
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:ansvel/homeandregistratiodesign/views/wallet/add_wallet_screen.dart';
import 'package:ansvel/movedforhomepage/vertical_image_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


/// **Model for HomeCategoryServices**
class HomeCategoryService {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  HomeCategoryService({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  /// **Factory constructor to create an instance from Firestore data**
  factory HomeCategoryService.fromFirestore(Map<String, dynamic> data) {
    return HomeCategoryService(
      title: data['title'] ?? "Unknown",
      icon: getIconData(data['icon'] ?? ""),
      onTap: getOnTapFunction(data['onTap'] ?? ""),
    );
  }

  /// **🔥 Fully Dynamic Icon Parsing (Reflection)**
  static IconData getIconData(String iconName) {
    try {
      return IconData(
        int.parse(iconName),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      return Icons.help_outline; // Fallback if icon not found
    }
  }

  /// **🚀 Dynamic onTap Function Without Hardcoded Mapping**
  static VoidCallback getOnTapFunction(String screenName) {
    return () {
      if (Get.routeTree.routes.any((route) => route.name == screenName)) {
        Get.toNamed(screenName);
      } else {
        Get.snackbar("Error", "Unknown Navigation: $screenName");
      }
    };
  }

  /// **Offline Fallback Data (For No Internet)**
  static List<HomeCategoryService> offlineData() {
    return [
      HomeCategoryService(
        title: "New Wallet",
        icon: Icons.add,
        onTap: () {
          Get.off(() => AddWalletScreen());
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => const AddWalletScreen()),
          // );
        },
        
      ),
      HomeCategoryService(
        title: "Food Ordering",
        icon: Icons.food_bank,
        onTap: () {
          // Get.off(() => ComingSoonScreen());
        },
      ),
      HomeCategoryService(
        title: "Groceries",
        icon: Icons.local_grocery_store,
        onTap: () {
          // Get.off(() => ComingSoonScreen());
        },
      ),
      HomeCategoryService(
        title: "Ride Hailing",
        icon: Icons.car_rental,
        onTap: () {
          // Get.off(() => ComingSoonScreen());
        },
      ),
      HomeCategoryService(
        title: "Chess",
        icon: Icons.gamepad,
        onTap: () {},
      ),
      HomeCategoryService(
        title: "Tetris",
        icon: Icons.gamepad,
        onTap: () {},
      ),
      HomeCategoryService(
        title: "Puzzle",
        icon: Icons.gamepad,
        onTap: () {},
      ),
      HomeCategoryService(
        title: "Service Finder",
        icon: Icons.cleaning_services,
        onTap: () {
          // Get.off(() => ComingSoonScreen());
        },
      ),
      HomeCategoryService(
        title: "Hotel Booking",
        icon: Icons.hotel,
        onTap: () {
          // Get.off(() => ComingSoonScreen());
        },
      ),
      HomeCategoryService(
        title: "News",
        icon: Icons.newspaper,
        onTap: () {
          // Get.off(() => ComingSoonScreen());
        },
      ),
      HomeCategoryService(
        title: "Real Estate",
        icon: Icons.real_estate_agent,
        onTap: () {
          // Get.off(() => ComingSoonScreen());
        },
      ),
    ];
  }
}

/// **🏠 Widget to Display Firebase Data Using TVerticalImageText**
class HomeCategoryServices extends StatefulWidget {
  const HomeCategoryServices({super.key});

  @override
  _HomeCategoryServicesState createState() => _HomeCategoryServicesState();
}

class _HomeCategoryServicesState extends State<HomeCategoryServices> {
  List<HomeCategoryService> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  /// **🔄 Fetch Services from Firebase**
  Future<void> fetchServices() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('POPULARSERVICES').get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          services = querySnapshot.docs
              .map((doc) => HomeCategoryService.fromFirestore(doc.data()))
              .toList();
        });
      } else {
        setState(() {
          services = HomeCategoryService.offlineData();
        });
      }
    } catch (e) {
      setState(() {
        services = HomeCategoryService.offlineData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SizedBox.shrink(); // Return an empty widget if no data
    }

    return SizedBox(
      height: 110,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: services.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return TVerticalImageText(
            icon: services[index].icon,
            title: services[index].title,
            onTap: services[index].onTap,
          );
        },
      ),
    );
  }
}
