import 'dart:async';
// import 'package:ansvel/game/snakegame2/snakegame2.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/constants/sizes.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/image_strings.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/sizes.dart';
import 'package:ansvel/homeandregistratiodesign/views/feedback/feedbackscreen.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/add_wallet_screen.dart';
import 'package:ansvel/main.dart';
import 'package:ansvel/movedforhomepage/advert_slider.dart';
import 'package:ansvel/movedforhomepage/app_them_data.dart';
import 'package:ansvel/movedforhomepage/home_category_services.dart';
import 'package:ansvel/movedforhomepage/homeappbar.dart';
import 'package:ansvel/movedforhomepage/my_button.dart';
import 'package:ansvel/movedforhomepage/partnerinformationform.dart';
import 'package:ansvel/movedforhomepage/primary_header_container.dart';
import 'package:ansvel/movedforhomepage/search_container.dart';
import 'package:ansvel/movedforhomepage/section_heading.dart';
import 'package:ansvel/movedforhomepage/snakegame2/snakegame2.dart';
import 'package:ansvel/movedforhomepage/top_courses.dart';
import 'package:ansvel/referralsystem/screens/refhomepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Game Imports
// import 'package:ansvel/game/chessgame/gameBoard.dart';
// import 'package:ansvel/game/snakegame/main.dart';
// import 'package:ansvel/game/stacksgame/stacksgamehomepage.dart';
// import 'package:ansvel/game/tetris/screens/splash.dart';
// import 'package:ansvel/game/wordle/pages/home_page.dart';

// Core Components
// import 'package:ansvel/loginapp/src/constants/sizes.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/advert_slider.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/feedback/feedbackform.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/partnershipprogram/partnerinformationform.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/appbar/homeappbar.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/custome_shapes/containers/primary_header_container.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/custome_shapes/containers/search_container.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/home/widget/home_category_services.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/texts/section_heading.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/constants/image_strings.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/my_button.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/widgets/top_courses.dart';

// // Feature Imports
// import 'package:ansvel/referralsystem/screens/home_page.dart';
// import 'package:ansvel/ridewithme/app/dashboard_screen.dart';
// import 'package:ansvel/ridewithme/app/wallet_screen/wallet_screen.dart';
// import 'package:ansvel/ridewithme/themes/app_them_data.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : AppThemeData.primary50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(isDark),
            _buildAdvertSection(),
            _buildTransportServicesSection(isDark),
            _buildGamesSection(isDark),
            _buildPartnershipBannerSection(isDark),
            _buildTopCoursesSection(textTheme, isDark),
          ],
        ),
      ),
      floatingActionButton: PanicButton(),
    );
  }

  Widget _buildHeaderSection(bool isDark) {
    return TPrimaryHeaderContainer(
      child: Column(
        children: [
          // const THomeAppBar2(),
          // const SizedBox(height: TSizes.spaceBtwSections - 10),
          const THomeAppBar(),
          const SizedBox(height: TSizes.spaceBtwSections - 10),
          const TSearchContainer(text: 'Search for Services'),
          const SizedBox(height: TSizes.spaceBtwItems),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                TSectionHeading(
                  title: 'Popular Services',
                  showActionButton: false,
                  textColor: isDark ? Colors.black : Colors.white,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const HomeCategoryServices(),
                _buildActionButtonsSection(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
            onTap: () => Get.offAll(const FeedbackScreen()),
            backgroundColor: Colors.greenAccent,
            title: 'Feedback',
            icon: Icons.feedback,
            textColor: isDark ? Colors.white : Colors.black,
          ),
          CustomIconButton(
            onTap: () => Get.offAll(const RefHomePage()),
            backgroundColor: Colors.white,
            title: 'Referral',
            icon: Icons.share,
            textColor: isDark ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertSection() {
    return const Padding(
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: TAdvertSlider(
        banners: [
          TImages.promoBanner1,
          TImages.promoBanner2,
          TImages.promoBanner3,
        ],
      ),
    );
  }

  Widget _buildTransportServicesSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          TSectionHeading(
            title: 'Transport Services',
            showActionButton: false,
            textColor: isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Wrap(
            spacing: 3.0,
            runSpacing: 25.0,
            children: [
              _buildTransportButton(
                icon: Icons.car_rental,
                text: "Ride\nSharing",
                // onTap: () => Get.to(const DashBoardScreen()),
                onTap: () {},
              ),
              _buildTransportButton(
                icon: Icons.wallet,
                text: "Fund Your\nWallet",
                //onTap: () => Get.to(() => const WalletScreen()),
                onTap: () {},
              ),
              _buildTransportButton(
                icon: Icons.cut, // Using scissors icon for tailor
                text: "Tailor\nApp",
                onTap: () =>
                    Get.toNamed('/tailor-home'), // This calls your Tailor app
              ),
              _buildTransportButton(
                icon: Icons.cut, // Using scissors icon for tailor
                text: "Tailor2\nApp",
                onTap: () =>
                    Get.toNamed('/blue-moon'), // This calls your Tailor app
              ),
               _buildTransportButton(
                icon: Icons.cut, // Using scissors icon for tailor
                text: "Tailor3\nApp",
                onTap: () =>
                    Get.toNamed('/tailor-bhai'), // This calls your Tailor app
              ),
             
  // _buildTransportButton(
  //   icon: Icons.cut, // Using scissors icon for tailor
  //   text: "Tailor\nApp",
  //   onTap: () => launchTailorApp(context),
  // ),
            ],
          ),
          const SizedBox(height: tDefaultSpace),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildTransportButton(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return MyButton(
      onTap: onTap,
      iconButton: icon,
      height: 120,
      width: 90,
      buttonText: text,
      color: Colors.green,
      borderradius: 20,
    );
  }

  Widget _buildGamesSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          TSectionHeading(
            title: 'Games',
            showActionButton: false,
            textColor: isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Wrap(
            spacing: 3.0,
            runSpacing: 25.0,
            children: [
              _buildGameButton(
                destination: SnakeGamePage(),
                text: "Stacks\nGame",
                color: Colors.lightBlueAccent.shade700,
              ),
              _buildGameButton(
                // destination: BoardGame(),
                destination: SnakeGamePage(),
                text: "Chess\nGame",
                color: Colors.lightBlueAccent.shade700,
              ),
              _buildGameButton(
                // destination: SnakeGameHomePage(),
                destination: SnakeGamePage(),
                text: "Snake\nGame",
                color: Colors.deepOrangeAccent.shade700,
              ),
              _buildGameButton(
                // destination: TetrisSplash(),
                destination: SnakeGamePage(),
                text: "Tetris",
                color: Colors.deepPurple.shade700,
              ),
              _buildGameButton(
                destination: SnakeGamePage(),
                text: "Snake\nGame",
                color: const Color.fromARGB(255, 168, 23, 170),
              ),
              _buildGameButton(
                // destination: WordleHomePage(),
                destination: SnakeGamePage(),
                text: "Wordle",
                color: Colors.yellow.shade700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameButton(
      {required Widget destination,
      required String text,
      required Color color}) {
    return MyButton(
      onTap: () => Get.to(() => destination),
      iconButton: Icons.games,
      height: 120,
      width: 90,
      buttonText: text,
      color: color,
      borderradius: 20,
    );
  }

  Widget _buildPartnershipBannerSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/advert1background.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade800,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 10,
            offset: Offset(-4, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset("assets/thinkingemoji.png",
                    width: 100, height: 100),
                Expanded(
                  child: Text(
                    "Do you run a financial service or tech solution? Integrate with us and reach millions of users.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CustomIconButton(
                onTap: () => Get.off(() => PartnerInformationForm()),
                backgroundColor: Colors.greenAccent,
                title: 'Contact Us',
                icon: Icons.phone,
                textColor: isDark ? Colors.white : Colors.black,
                width: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCoursesSection(TextTheme textTheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const Divider(),
          DashboardTopCourses(txtTheme: textTheme, isDark: isDark),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final String title;
  final IconData icon;
  final Color textColor;
  final double width;

  const CustomIconButton({
    required this.onTap,
    required this.backgroundColor,
    required this.title,
    required this.icon,
    required this.textColor,
    this.width = 180,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: textColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PanicButton extends StatefulWidget {
  @override
  _PanicButtonState createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton> {
  bool _isPanicking = false;
  LocationData? _currentLocation;
  Location _locationService = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  Timer? _locationTimer;
  User? _user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(_user!.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _userData = userDoc.data() as Map<String, dynamic>;
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
      ),
      childWhenDragging: Container(),
      onDragEnd: (details) {
        // Save position if needed
      },
      child: FloatingActionButton(
        onPressed: _handlePanicButtonPress,
        backgroundColor: _isPanicking ? Colors.red[900] : Colors.red,
        child: Icon(
          _isPanicking ? Icons.location_on : Icons.warning_amber_rounded,
          color: Colors.white,
          size: 30,
        ),
        tooltip: 'Emergency Panic Button',
      ),
    );
  }

  Future<void> _handlePanicButtonPress() async {
    if (_isPanicking) {
      Get.snackbar(
        'Emergency Mode Active',
        'Help is already on the way! Your location is being shared.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    bool? confirm = await Get.dialog(
      AlertDialog(
        title: Text('🚨 EMERGENCY PANIC BUTTON 🚨',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 60),
              SizedBox(height: 20),
              Text(
                'Pressing "EMERGENCY" will immediately:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('• Call the police hotline (+2347034176342)'),
              Text('• Share your live location with authorities'),
              Text('• Send your profile details to emergency contacts'),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'WARNING: False alarms will result in a ₦50,000 fine '
                  'and may lead to account suspension.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('CANCEL', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => Get.back(result: true),
            child: Text('EMERGENCY', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isPanicking = true);

      // Make emergency call
      await _makeEmergencyCall();

      // Send alerts with user data
      await _sendEmergencyAlerts();

      // Start location sharing
      await _startLocationSharing();

      // Start periodic location updates
      _locationTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        _shareCurrentLocation();
      });

      Get.snackbar(
        'Emergency Alert Activated',
        'Help is on the way! Authorities have been notified.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    }
  }

  Future<void> _makeEmergencyCall() async {
    const policeHotline = '+2347034176342';
    final url = 'tel:$policeHotline';

    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error making emergency call: $e');
      Get.snackbar(
        'Call Failed',
        'Could not make emergency call. Please try again or call directly.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _sendEmergencyAlerts() async {
    if (_userData == null) {
      await _fetchUserData();
      if (_userData == null) return;
    }

    final userInfo = '''
🚨 EMERGENCY ALERT 🚨
User ID: ${_user?.uid}
Name: ${_userData?['fullName'] ?? 'Unknown'}
Phone: ${_userData?['phoneNo'] ?? 'Unknown'}
I feel unsafe and need immediate assistance!
''';

    // Send to WhatsApp contacts
    await _sendWhatsAppAlert(userInfo);

    // Send to Telegram
    await _sendTelegramAlert(userInfo);
  }

  Future<void> _sendWhatsAppAlert(String message) async {
    const individualNumber = '+2348051517184';
    const whatsappGroupLink = 'https://chat.whatsapp.com/YOUR_GROUP_LINK';

    final individualUrl =
        'https://wa.me/$individualNumber?text=${Uri.encodeComponent(message)}';
    final groupUrl = '$whatsappGroupLink?text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunch(individualUrl)) {
        await launch(individualUrl);
      }
      await Future.delayed(Duration(seconds: 2));
      if (await canLaunch(groupUrl)) {
        await launch(groupUrl);
      }
    } catch (e) {
      print('WhatsApp error: $e');
    }
  }

  Future<void> _sendTelegramAlert(String message) async {
    const botToken = 'YOUR_BOT_TOKEN';
    const chatId = 'YOUR_CHAT_ID';
    final url =
        'https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatId&text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print('Telegram error: $e');
    }
  }

  Future<void> _startLocationSharing() async {
    try {
      _serviceEnabled = await _locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _locationService.requestService();
        if (!_serviceEnabled) {
          throw 'Location services disabled';
        }
      }

      _permissionGranted = await _locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          throw 'Location permission denied';
        }
      }

      _currentLocation = await _locationService.getLocation();
      await _shareCurrentLocation();

      _locationService.onLocationChanged.listen((location) {
        _currentLocation = location;
      });
    } catch (e) {
      print('Location error: $e');
      Get.snackbar(
        'Location Error',
        'Could not share location: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _shareCurrentLocation() async {
    if (_currentLocation == null || _userData == null) return;

    final locationMessage = '''
📍 EMERGENCY LOCATION UPDATE
User: ${_userData?['fullName'] ?? 'Unknown'}
Phone: ${_userData?['phoneNo'] ?? 'Unknown'}
Time: ${DateTime.now().toString()}
Map Link: https://www.google.com/maps?q=${_currentLocation!.latitude},${_currentLocation!.longitude}
Accuracy: ${_currentLocation!.accuracy?.toStringAsFixed(2) ?? 'Unknown'} meters
''';

    await _sendWhatsAppAlert(locationMessage);
    await _sendTelegramAlert(locationMessage);
  }
}

class THomeAppBar2 extends StatelessWidget {
  const THomeAppBar2({super.key});
  @override
  Widget build(BuildContext context) => AppBar(
    title: const Text("Ansvel Home"),
    actions: [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddWalletScreen()),
          );
        },
      ),
    ],
  );
}
