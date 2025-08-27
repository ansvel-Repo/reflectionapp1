import 'package:ansvel/firebase_options.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/home_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/onboarding_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/security_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/wallet_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/ad_management_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/home_page.dart';
import 'package:ansvel/homeandregistratiodesign/views/home_page2.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/address_collection_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/bvn_input_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/complete_kyc_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/create_wallet_summary_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/merchant_type_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/splash_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/welcome_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/forgot_password_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/forgot_pin_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/login_interception_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/new_password_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/settings/settings.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/create_wallet_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/transaction_history_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/other_bank_transfer/transfer_to_bank_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/transfer_to_wallet_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/wallet_dashboard_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// --- App Entry Point ---
void main() async {
  // Ensure Flutter is initialized before any services
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the generated options file
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AnsvelApp());
}

class AnsvelApp extends StatelessWidget {
  const AnsvelApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider makes your controllers available to the entire app.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => OnboardingController()),
        ChangeNotifierProvider(create: (_) => SecurityController()),
        ChangeNotifierProvider(
          create: (_) => WalletController(),
        ), // Added WalletController
      ],
      child: MaterialApp(
        title: 'Ansvel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: const Color(0xFFF7F8FC),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          useMaterial3: true,
          // Define a consistent and beautiful theme for buttons and inputs
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        home: const SplashScreen(), // Always start with the splash screen
      ),
    );
  }
}

// This wrapper is now used AFTER the splash/onboarding flow.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        if (authController.isLoggedIn) {
          // If the user is logged in, show the HomePage
          return const HomePage();
        } else {
          // If not logged in, show the Login/Signup screen
          // return const WelcomeScreen();
          //return  NewPasswordScreen(email: 'pakudike@outlook.com',);
          return MerchantTypeSelectionScreen();
        }
      },
    );
  }
}

// // // // import 'package:flutter/material.dart';

// // // // void main() {
// // // //   runApp(const MyApp());
// // // // }

// // // // class MyApp extends StatelessWidget {
// // // //   const MyApp({super.key});

// // // //   // This widget is the root of your application.
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       title: 'Flutter Demo',
// // // //       theme: ThemeData(
// // // //         // This is the theme of your application.
// // // //         //
// // // //         // TRY THIS: Try running your application with "flutter run". You'll see
// // // //         // the application has a purple toolbar. Then, without quitting the app,
// // // //         // try changing the seedColor in the colorScheme below to Colors.green
// // // //         // and then invoke "hot reload" (save your changes or press the "hot
// // // //         // reload" button in a Flutter-supported IDE, or press "r" if you used
// // // //         // the command line to start the app).
// // // //         //
// // // //         // Notice that the counter didn't reset back to zero; the application
// // // //         // state is not lost during the reload. To reset the state, use hot
// // // //         // restart instead.
// // // //         //
// // // //         // This works for code too, not just values: Most code changes can be
// // // //         // tested with just a hot reload.
// // // //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// // // //       ),
// // // //       home: const MyHomePage(title: 'Flutter Demo Home Page'),
// // // //     );
// // // //   }
// // // // }

// // // // class MyHomePage extends StatefulWidget {
// // // //   const MyHomePage({super.key, required this.title});

// // // //   // This widget is the home page of your application. It is stateful, meaning
// // // //   // that it has a State object (defined below) that contains fields that affect
// // // //   // how it looks.

// // // //   // This class is the configuration for the state. It holds the values (in this
// // // //   // case the title) provided by the parent (in this case the App widget) and
// // // //   // used by the build method of the State. Fields in a Widget subclass are
// // // //   // always marked "final".

// // // //   final String title;

// // // //   @override
// // // //   State<MyHomePage> createState() => _MyHomePageState();
// // // // }

// // // // class _MyHomePageState extends State<MyHomePage> {
// // // //   int _counter = 0;

// // // //   void _incrementCounter() {
// // // //     setState(() {
// // // //       // This call to setState tells the Flutter framework that something has
// // // //       // changed in this State, which causes it to rerun the build method below
// // // //       // so that the display can reflect the updated values. If we changed
// // // //       // _counter without calling setState(), then the build method would not be
// // // //       // called again, and so nothing would appear to happen.
// // // //       _counter++;
// // // //     });
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     // This method is rerun every time setState is called, for instance as done
// // // //     // by the _incrementCounter method above.
// // // //     //
// // // //     // The Flutter framework has been optimized to make rerunning build methods
// // // //     // fast, so that you can just rebuild anything that needs updating rather
// // // //     // than having to individually change instances of widgets.
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         // TRY THIS: Try changing the color here to a specific color (to
// // // //         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
// // // //         // change color while the other colors stay the same.
// // // //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// // // //         // Here we take the value from the MyHomePage object that was created by
// // // //         // the App.build method, and use it to set our appbar title.
// // // //         title: Text(widget.title),
// // // //       ),
// // // //       body: Center(
// // // //         // Center is a layout widget. It takes a single child and positions it
// // // //         // in the middle of the parent.
// // // //         child: Column(
// // // //           // Column is also a layout widget. It takes a list of children and
// // // //           // arranges them vertically. By default, it sizes itself to fit its
// // // //           // children horizontally, and tries to be as tall as its parent.
// // // //           //
// // // //           // Column has various properties to control how it sizes itself and
// // // //           // how it positions its children. Here we use mainAxisAlignment to
// // // //           // center the children vertically; the main axis here is the vertical
// // // //           // axis because Columns are vertical (the cross axis would be
// // // //           // horizontal).
// // // //           //
// // // //           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
// // // //           // action in the IDE, or press "p" in the console), to see the
// // // //           // wireframe for each widget.
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: <Widget>[
// // // //             const Text('You have pushed the button this many times:'),
// // // //             Text(
// // // //               '$_counter',
// // // //               style: Theme.of(context).textTheme.headlineMedium,
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //       floatingActionButton: FloatingActionButton(
// // // //         onPressed: _incrementCounter,
// // // //         tooltip: 'Increment',
// // // //         child: const Icon(Icons.add),
// // // //       ), // This trailing comma makes auto-formatting nicer for build methods.
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:lottie/lottie.dart';
// // // import 'package:confetti/confetti.dart';
// // // import 'package:page_transition/page_transition.dart';
// // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // import 'dart:math';

// // // // --- App Entry Point ---
// // // void main() {
// // //   runApp(const AnsvelApp());
// // // }

// // // class AnsvelApp extends StatelessWidget {
// // //   const AnsvelApp({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Ansvel',
// // //       debugShowCheckedModeBanner: false,
// // //       theme: ThemeData(
// // //         primarySwatch: Colors.blue,
// // //         scaffoldBackgroundColor: const Color(0xFFF7F8FC),
// // //         textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
// // //       ),
// // //       home: const WelcomeScreen(),
// // //     );
// // //   }
// // // }

// // // // --- Scene 1: Introduction & App Welcome ---
// // // class WelcomeScreen extends StatefulWidget {
// // //   const WelcomeScreen({super.key});

// // //   @override
// // //   State<WelcomeScreen> createState() => _WelcomeScreenState();
// // // }

// // // class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
// // //   late AnimationController _controller;
// // //   late Animation<double> _scaleAnimation;
// // //   late Animation<double> _fadeAnimation;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _controller = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(milliseconds: 2500),
// // //     );

// // //     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
// // //       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
// // //     );

// // //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// // //       CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
// // //     );

// // //     _controller.forward();

// // //     // Navigate to the next screen after the animation
// // //     Future.delayed(const Duration(seconds: 4), () {
// // //       Navigator.pushReplacement(
// // //         context,
// // //         PageTransition(type: PageTransitionType.fade, child: const BvnInputScreen()),
// // //       );
// // //     });
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _controller.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFF0A1128),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             ScaleTransition(
// // //               scale: _scaleAnimation,
// // //               child: Image.asset(
// // //                 'assets/images/ansvel_logo.png', // Ensure you have this logo
// // //                 width: 150,
// // //               ),
// // //             ),
// // //             const SizedBox(height: 24),
// // //             FadeTransition(
// // //               opacity: _fadeAnimation,
// // //               child: Text(
// // //                 'Ansvel: Your Digital Wallet, Your Way.',
// // //                 style: GoogleFonts.poppins(
// // //                   fontSize: 18,
// // //                   fontWeight: FontWeight.w500,
// // //                   color: Colors.white,
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // --- Onboarding Screens Wrapper ---
// // // abstract class OnboardingStepScreen extends StatelessWidget {
// // //   final String title;
// // //   final String subtitle;
// // //   final int step;

// // //   const OnboardingStepScreen({
// // //     super.key,
// // //     required this.title,
// // //     required this.subtitle,
// // //     required this.step,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.transparent,
// // //         elevation: 0,
// // //         leading: IconButton(
// // //           icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
// // //           onPressed: () => Navigator.of(context).pop(),
// // //         ),
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Step $step of 5',
// // //               style: GoogleFonts.poppins(
// // //                 color: const Color(0xFF4A90E2),
// // //                 fontWeight: FontWeight.bold,
// // //                 fontSize: 16,
// // //               ),
// // //             ),
// // //             const SizedBox(height: 8),
// // //             Text(
// // //               title,
// // //               style: GoogleFonts.poppins(
// // //                 fontSize: 28,
// // //                 fontWeight: FontWeight.bold,
// // //                 color: const Color(0xFF0A1128),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             Text(
// // //               subtitle,
// // //               style: GoogleFonts.poppins(
// // //                 fontSize: 16,
// // //                 color: Colors.black54,
// // //                 height: 1.5,
// // //               ),
// // //             ),
// // //             const SizedBox(height: 40),
// // //             Expanded(child: buildBody(context)),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget buildBody(BuildContext context);
// // // }

// // // // --- Scene 2: BVN Input ---
// // // class BvnInputScreen extends OnboardingStepScreen {
// // //   const BvnInputScreen({super.key})
// // //       : super(
// // //           title: "Secure Your Wallet",
// // //           subtitle: "To create your digital wallet, we'll start with your Bank Verification Number (BVN). We securely pass this to our partner to instantly create your wallet.",
// // //           step: 1,
// // //         );

// // //   @override
// // //   Widget buildBody(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         _buildTextField(label: "Enter your 11-digit BVN", icon: FontAwesomeIcons.buildingColumns),
// // //         const Spacer(),
// // //         _buildContinueButton(onPressed: () {
// // //           Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const ProcessingScreen(nextScreen: NinInputScreen())));
// // //         }),
// // //       ],
// // //     );
// // //   }
// // // }

// // // // --- Scene 4: NIN Input ---
// // // class NinInputScreen extends OnboardingStepScreen {
// // //   const NinInputScreen({super.key})
// // //       : super(
// // //           title: "Verify Your Identity",
// // //           subtitle: "Next, we need your National Identification Number (NIN). We perform an instant, automatic verification to ensure your identity is confirmed.",
// // //           step: 2,
// // //         );

// // //   @override
// // //   Widget buildBody(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         _buildTextField(label: "Enter your NIN", icon: FontAwesomeIcons.solidAddressCard),
// // //         const Spacer(),
// // //         _buildContinueButton(onPressed: () {
// // //             Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const ContactInfoScreen()));
// // //         }),
// // //       ],
// // //     );
// // //   }
// // // }

// // // // --- Scene 5: Contact Information ---
// // // class ContactInfoScreen extends OnboardingStepScreen {
// // //   const ContactInfoScreen({super.key})
// // //       : super(
// // //           title: "Provide Contact Details",
// // //           subtitle: "Please provide your phone number and residential address. You can choose to provide proof of address now, or save it for a later upgrade.",
// // //           step: 3,
// // //         );

// // //   @override
// // //   Widget buildBody(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         _buildTextField(label: "Phone Number", icon: FontAwesomeIcons.phone, keyboardType: TextInputType.phone),
// // //         const SizedBox(height: 20),
// // //         _buildTextField(label: "Residential Address", icon: FontAwesomeIcons.house),
// // //         const SizedBox(height: 20),
// // //         const Spacer(),
// // //         _buildContinueButton(onPressed: () {
// // //             Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const SelfieLivenessScreen()));
// // //         }),
// // //       ],
// // //     );
// // //   }
// // // }

// // // // --- Scene 6: Selfie & Liveness Check ---
// // // class SelfieLivenessScreen extends OnboardingStepScreen {
// // //   const SelfieLivenessScreen({super.key})
// // //       : super(
// // //           title: "Confirm Your Liveness",
// // //           subtitle: "Take a quick selfie. This helps us conduct a liveness check to ensure it's really you and compares it with your NIN image.",
// // //           step: 4,
// // //         );

// // //   @override
// // //   Widget buildBody(BuildContext context) {
// // //     return Column(
// // //       mainAxisAlignment: MainAxisAlignment.center,
// // //       children: [
// // //         Container(
// // //           height: 250,
// // //           width: 250,
// // //           decoration: BoxDecoration(
// // //             shape: BoxShape.circle,
// // //             border: Border.all(color: const Color(0xFF4A90E2), width: 4),
// // //             color: Colors.grey[200],
// // //           ),
// // //           child: const Icon(FontAwesomeIcons.cameraRetro, size: 80, color: Color(0xFF4A90E2)),
// // //         ),
// // //         const SizedBox(height: 30),
// // //         Text(
// // //           "Center your face in the frame",
// // //           style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
// // //         ),
// // //         const Spacer(),
// // //         _buildContinueButton(
// // //           text: "Open Camera",
// // //           onPressed: () {
// // //             // In a real app, you would use the 'camera' package here.
// // //             // For this simulation, we go straight to the next step.
// // //              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const SecurityCheckScreen()));
// // //           },
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // // --- Scene 7: Background Screening ---
// // // class SecurityCheckScreen extends OnboardingStepScreen {
// // //   const SecurityCheckScreen({super.key})
// // //       : super(
// // //           title: "Advanced Security Check",
// // //           subtitle: "For your security and compliance, we conduct a robust background screening. This will only take a moment.",
// // //           step: 5,
// // //         );

// // //   @override
// // //   Widget buildBody(BuildContext context) {
// // //     // Navigate to final screen after all checks are 'done'.
// // //     Future.delayed(const Duration(seconds: 7), () {
// // //        Navigator.pushAndRemoveUntil(
// // //         context,
// // //         PageTransition(type: PageTransitionType.fade, child: const Tier2ActivationScreen()),
// // //         (route) => false,
// // //       );
// // //     });

// // //     return const Column(
// // //       mainAxisAlignment: MainAxisAlignment.center,
// // //       children: [
// // //         SecurityCheckItem(
// // //           text: "Screening against Blacklists...",
// // //           delay: Duration(seconds: 1),
// // //         ),
// // //         SizedBox(height: 30),
// // //         SecurityCheckItem(
// // //           text: "Checking Politically Exposed Persons (PEP) lists...",
// // //           delay: Duration(seconds: 3),
// // //         ),
// // //         SizedBox(height: 30),
// // //         SecurityCheckItem(
// // //           text: "Scanning for Adverse Media reports...",
// // //           delay: Duration(seconds: 5),
// // //         ),
// // //         SizedBox(height: 40),
// // //       ],
// // //     );
// // //   }
// // // }

// // // class SecurityCheckItem extends StatefulWidget {
// // //   final String text;
// // //   final Duration delay;

// // //   const SecurityCheckItem({super.key, required this.text, required this.delay});

// // //   @override
// // //   State<SecurityCheckItem> createState() => _SecurityCheckItemState();
// // // }

// // // class _SecurityCheckItemState extends State<SecurityCheckItem> {
// // //   bool _isChecking = true;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     Future.delayed(widget.delay, () {
// // //       if (mounted) {
// // //         setState(() {
// // //           _isChecking = false;
// // //         });
// // //       }
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Row(
// // //       children: [
// // //         AnimatedSwitcher(
// // //           duration: const Duration(milliseconds: 500),
// // //           transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
// // //           child: _isChecking
// // //               ? const SizedBox(
// // //                   key: ValueKey('loader'),
// // //                   width: 24,
// // //                   height: 24,
// // //                   child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF4A90E2)),
// // //                 )
// // //               : const Icon(
// // //                   key: ValueKey('check'),
// // //                   FontAwesomeIcons.solidCircleCheck,
// // //                   color: Color(0xFF28a745),
// // //                   size: 24,
// // //                 ),
// // //         ),
// // //         const SizedBox(width: 20),
// // //         Expanded(
// // //           child: Text(
// // //             widget.text,
// // //             style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // // --- Scene 3 & Intermediate Processing Screen ---
// // // class ProcessingScreen extends StatefulWidget {
// // //   final Widget nextScreen;

// // //   const ProcessingScreen({super.key, required this.nextScreen});

// // //   @override
// // //   State<ProcessingScreen> createState() => _ProcessingScreenState();
// // // }

// // // class _ProcessingScreenState extends State<ProcessingScreen> {
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     Future.delayed(const Duration(seconds: 3), () {
// // //       Navigator.pushReplacement(
// // //         context,
// // //         PageTransition(type: PageTransitionType.fade, duration: const Duration(milliseconds: 500), child: SuccessScreen(nextScreen: widget.nextScreen)),
// // //       );
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Lottie.asset(
// // //               'assets/lottie/processing.json', // Your Lottie file for processing
// // //               width: 200,
// // //               height: 200,
// // //             ),
// // //             const SizedBox(height: 20),
// // //             Text(
// // //               "Processing...",
// // //               style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
// // //             ),
// // //             const SizedBox(height: 10),
// // //             Text(
// // //               "Creating your secure wallet.",
// // //               style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // --- Success Screen ---
// // // class SuccessScreen extends StatelessWidget {
// // //   final Widget nextScreen;
// // //   const SuccessScreen({super.key, required this.nextScreen});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(24.0),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           crossAxisAlignment: CrossAxisAlignment.stretch,
// // //           children: [
// // //             Lottie.asset(
// // //               'assets/lottie/success.json', // Your Lottie file for success
// // //               width: 150,
// // //               height: 150,
// // //               repeat: false,
// // //             ),
// // //             const SizedBox(height: 30),
// // //             Text(
// // //               "Success! Wallet Created.",
// // //               textAlign: TextAlign.center,
// // //               style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             Card(
// // //               elevation: 4,
// // //               shadowColor: Colors.black.withOpacity(0.1),
// // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //               child: Padding(
// // //                 padding: const EdgeInsets.all(20.0),
// // //                 child: Column(
// // //                   children: [
// // //                     _buildInfoRow("Account Holder:", "JOHN DOE"),
// // //                     const Divider(height: 20, thickness: 1),
// // //                     _buildInfoRow("Account Number:", "2345678901"),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 50),
// // //             _buildContinueButton(
// // //               onPressed: () {
// // //                 Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: nextScreen));
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildInfoRow(String label, String value) {
// // //     return Row(
// // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //       children: [
// // //         Text(
// // //           label,
// // //           style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
// // //         ),
// // //         Text(
// // //           value,
// // //           style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // // --- Scene 8: Tier 2 Account Activation ---
// // // class Tier2ActivationScreen extends StatefulWidget {
// // //   const Tier2ActivationScreen({super.key});

// // //   @override
// // //   State<Tier2ActivationScreen> createState() => _Tier2ActivationScreenState();
// // // }

// // // class _Tier2ActivationScreenState extends State<Tier2ActivationScreen> {
// // //   late ConfettiController _confettiController;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _confettiController = ConfettiController(duration: const Duration(seconds: 1));
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       _confettiController.play();
// // //     });
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _confettiController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Stack(
// // //       alignment: Alignment.topCenter,
// // //       children: [
// // //         Scaffold(
// // //           body: Padding(
// // //             padding: const EdgeInsets.all(24.0),
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               crossAxisAlignment: CrossAxisAlignment.stretch,
// // //               children: [
// // //                 const Icon(FontAwesomeIcons.award, color: Color(0xFF4A90E2), size: 100),
// // //                 const SizedBox(height: 30),
// // //                 Text(
// // //                   "Congratulations!",
// // //                   textAlign: TextAlign.center,
// // //                   style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
// // //                 ),
// // //                 const SizedBox(height: 10),
// // //                 Text(
// // //                   "You've unlocked a Tier 2 Account.",
// // //                   textAlign: TextAlign.center,
// // //                   style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54),
// // //                 ),
// // //                 const SizedBox(height: 40),
// // //                 Container(
// // //                    padding: const EdgeInsets.all(16),
// // //                    decoration: BoxDecoration(
// // //                      border: Border.all(color: const Color(0xFF4A90E2)),
// // //                      borderRadius: BorderRadius.circular(12),
// // //                      color: const Color(0xFF4A90E2).withOpacity(0.05)
// // //                    ),
// // //                    child: Row(
// // //                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //                      children: [
// // //                        _buildLimitInfo("Single Limit", "₦50,000"),
// // //                        const SizedBox(height: 50, child: VerticalDivider(thickness: 1)),
// // //                        _buildLimitInfo("Daily Limit", "₦200,000"),
// // //                      ],
// // //                    ),
// // //                 ),
// // //                 const SizedBox(height: 50),
// // //                 _buildContinueButton(
// // //                   text: "Start Transacting",
// // //                   onPressed: () {
// // //                     // Navigate to the app's home screen
// // //                     // For now, we can pop back to the first screen or show a dialog
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       const SnackBar(content: Text("Navigating to Home Screen!")),
// // //                     );
// // //                   },
// // //                 ),
// // //                 TextButton(
// // //                     onPressed: () {
// // //                         // In a real app, this would be in a settings/profile page
// // //                         Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const Tier3UpgradeScreen()));
// // //                     },
// // //                     child: Text(
// // //                         "Upgrade to Tier 3 for higher limits",
// // //                         style: GoogleFonts.poppins(color: const Color(0xFF4A90E2), fontWeight: FontWeight.w600)
// // //                     )
// // //                 )
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //         ConfettiWidget(
// // //           confettiController: _confettiController,
// // //           blastDirection: -pi / 2,
// // //           emissionFrequency: 0.05,
// // //           numberOfParticles: 20,
// // //           gravity: 0.1,
// // //           shouldLoop: false,
// // //           colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildLimitInfo(String label, String value) {
// // //     return Column(
// // //       children: [
// // //         Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
// // //         const SizedBox(height: 4),
// // //         Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0A1128))),
// // //       ],
// // //     );
// // //   }
// // // }

// // // // --- Scene 9 & 10 (Combined for brevity) ---
// // // class Tier3UpgradeScreen extends StatelessWidget {
// // //     const Tier3UpgradeScreen({super.key});

// // //     @override
// // //     Widget build(BuildContext context) {
// // //         return Scaffold(
// // //              appBar: AppBar(
// // //                 title: Text("Account Upgrade", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
// // //                 centerTitle: true,
// // //             ),
// // //             body: ListView(
// // //                 padding: const EdgeInsets.all(24.0),
// // //                 children: [
// // //                     _buildSectionHeader("Upgrade to Tier 3", "Unlock our highest transaction limits by providing a proof of address."),
// // //                     const SizedBox(height: 20),
// // //                     ElevatedButton.icon(
// // //                       style: ElevatedButton.styleFrom(
// // //                         padding: const EdgeInsets.symmetric(vertical: 16),
// // //                         backgroundColor: const Color(0xFF4A90E2).withOpacity(0.1),
// // //                         foregroundColor: const Color(0xFF4A90E2),
// // //                         elevation: 0,
// // //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //                       ),
// // //                       onPressed: () { /* File picker logic here */ },
// // //                       icon: const Icon(FontAwesomeIcons.fileArrowUp),
// // //                       label: const Text("Upload Proof of Address")
// // //                     ),
// // //                     const SizedBox(height: 40),
// // //                     _buildSectionHeader("Complete Your Profile", "This helps us ensure the highest level of security and provide you with a tailored financial experience."),
// // //                     const SizedBox(height: 20),
// // //                     _buildTextField(label: "Next of Kin Name", icon: FontAwesomeIcons.userGroup),
// // //                     const SizedBox(height: 20),
// // //                     _buildTextField(label: "Next of Kin Phone", icon: FontAwesomeIcons.phone, keyboardType: TextInputType.phone),
// // //                     const SizedBox(height: 20),
// // //                     _buildTextField(label: "Source of Income", icon: FontAwesomeIcons.sackDollar),
// // //                     const SizedBox(height: 40),
// // //                      _buildContinueButton(text: "Save & Complete", onPressed: () => Navigator.pop(context)),
// // //                 ],
// // //             ),
// // //         );
// // //     }

// // //      Widget _buildSectionHeader(String title, String subtitle) {
// // //       return Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             title,
// // //             style: GoogleFonts.poppins(
// // //               fontSize: 22,
// // //               fontWeight: FontWeight.bold,
// // //               color: const Color(0xFF0A1128),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 8),
// // //           Text(
// // //             subtitle,
// // //             style: GoogleFonts.poppins(
// // //               fontSize: 15,
// // //               color: Colors.black54,
// // //             ),
// // //           ),
// // //         ],
// // //       );
// // //   }
// // // }

// // // // --- Reusable Widgets ---

// // // Widget _buildTextField({required String label, required IconData icon, TextInputType keyboardType = TextInputType.text}) {
// // //   return TextField(
// // //     keyboardType: keyboardType,
// // //     decoration: InputDecoration(
// // //       labelText: label,
// // //       labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
// // //       prefixIcon: Icon(icon, color: const Color(0xFF4A90E2), size: 20),
// // //       filled: true,
// // //       fillColor: Colors.white,
// // //       border: OutlineInputBorder(
// // //         borderRadius: BorderRadius.circular(12),
// // //         borderSide: BorderSide.none,
// // //       ),
// // //       focusedBorder: OutlineInputBorder(
// // //         borderRadius: BorderRadius.circular(12),
// // //         borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
// // //       ),
// // //     ),
// // //   );
// // // }

// // // Widget _buildContinueButton({required VoidCallback onPressed, String text = "Continue"}) {
// // //   return ElevatedButton(
// // //     onPressed: onPressed,
// // //     style: ElevatedButton.styleFrom(
// // //       backgroundColor: const Color(0xFF4A90E2),
// // //       padding: const EdgeInsets.symmetric(vertical: 16),
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //       elevation: 5,
// // //       shadowColor: const Color(0xFF4A90E2).withOpacity(0.4),
// // //     ),
// // //     child: Text(
// // //       text,
// // //       style: GoogleFonts.poppins(
// // //         fontSize: 18,
// // //         fontWeight: FontWeight.bold,
// // //         color: Colors.white,
// // //       ),
// // //     ),
// // //   );
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:lottie/lottie.dart';
// // import 'package:confetti/confetti.dart';
// // import 'package:page_transition/page_transition.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'dart:math';

// // // --- App Entry Point ---
// // void main() {
// //   runApp(const AnsvelApp());
// // }

// // class AnsvelApp extends StatelessWidget {
// //   const AnsvelApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Ansvel',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         scaffoldBackgroundColor: const Color(0xFFF7F8FC),
// //         textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
// //       ),
// //       home: const WelcomeScreen(),
// //     );
// //   }
// // }

// // // --- Scene 1: Introduction & App Welcome ---
// // class WelcomeScreen extends StatefulWidget {
// //   const WelcomeScreen({super.key});

// //   @override
// //   State<WelcomeScreen> createState() => _WelcomeScreenState();
// // }

// // class _WelcomeScreenState extends State<WelcomeScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _scaleAnimation;
// //   late Animation<double> _fadeAnimation;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 2500),
// //     );

// //     _scaleAnimation = Tween<double>(
// //       begin: 0.5,
// //       end: 1.0,
// //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

// //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
// //     );

// //     _controller.forward();

// //     // Navigate to the next screen after the animation
// //     Future.delayed(const Duration(seconds: 4), () {
// //       if (mounted) {
// //         Navigator.pushReplacement(
// //           context,
// //           PageTransition(
// //             type: PageTransitionType.fade,
// //             child: const BvnInputScreen(),
// //           ),
// //         );
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF0A1128),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             ScaleTransition(
// //               scale: _scaleAnimation,
// //               child: Image.asset(
// //                 'assets/images/ansvel_logo.png', // Ensure you have this logo
// //                 width: 150,
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             FadeTransition(
// //               opacity: _fadeAnimation,
// //               child: Text(
// //                 'Ansvel: Your Digital Wallet, Your Way.',
// //                 style: GoogleFonts.poppins(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w500,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // --- Onboarding Screens Wrapper ---
// // // This class is now a concrete widget that accepts a child widget for its body.
// // class OnboardingStepScreen extends StatelessWidget {
// //   final String title;
// //   final String subtitle;
// //   final int step;
// //   final int totalSteps;
// //   final Widget child;

// //   const OnboardingStepScreen({
// //     super.key,
// //     required this.title,
// //     required this.subtitle,
// //     required this.step,
// //     this.totalSteps = 5,
// //     required this.child,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         leading: step > 1
// //             ? IconButton(
// //                 icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
// //                 onPressed: () => Navigator.of(context).pop(),
// //               )
// //             : null,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Step $step of $totalSteps',
// //               style: GoogleFonts.poppins(
// //                 color: const Color(0xFF4A90E2),
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 16,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               title,
// //               style: GoogleFonts.poppins(
// //                 fontSize: 28,
// //                 fontWeight: FontWeight.bold,
// //                 color: const Color(0xFF0A1128),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             Text(
// //               subtitle,
// //               style: GoogleFonts.poppins(
// //                 fontSize: 16,
// //                 color: Colors.black54,
// //                 height: 1.5,
// //               ),
// //             ),
// //             const SizedBox(height: 40),
// //             Expanded(child: child),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // --- Scene 2: BVN Input ---
// // class BvnInputScreen extends StatelessWidget {
// //   const BvnInputScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return OnboardingStepScreen(
// //       title: "Secure Your Wallet",
// //       subtitle:
// //           "Start with your Bank Verification Number (BVN). We securely pass this to our partner, MoMo PSB, to instantly create your wallet.",
// //       step: 1,
// //       child: Column(
// //         children: [
// //           _buildTextField(
// //             label: "Enter your 11-digit BVN",
// //             icon: FontAwesomeIcons.buildingColumns,
// //             keyboardType: TextInputType.number,
// //           ),
// //           const Spacer(),
// //           _buildContinueButton(
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 PageTransition(
// //                   type: PageTransitionType.rightToLeft,
// //                   child: const ProcessingScreen(nextScreen: NinInputScreen()),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // --- Scene 4: NIN Input ---
// // class NinInputScreen extends StatelessWidget {
// //   const NinInputScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return OnboardingStepScreen(
// //       title: "Verify Your Identity",
// //       subtitle:
// //           "Next, we need your National Identification Number (NIN). We perform an instant, automatic verification to confirm your identity.",
// //       step: 2,
// //       child: Column(
// //         children: [
// //           _buildTextField(
// //             label: "Enter your NIN",
// //             icon: FontAwesomeIcons.solidAddressCard,
// //             keyboardType: TextInputType.number,
// //           ),
// //           const Spacer(),
// //           _buildContinueButton(
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 PageTransition(
// //                   type: PageTransitionType.rightToLeft,
// //                   child: const ContactInfoScreen(),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // --- Scene 5: Contact Information ---
// // class ContactInfoScreen extends StatefulWidget {
// //   const ContactInfoScreen({super.key});

// //   @override
// //   State<ContactInfoScreen> createState() => _ContactInfoScreenState();
// // }

// // class _ContactInfoScreenState extends State<ContactInfoScreen> {
// //   bool _uploadProofNow = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return OnboardingStepScreen(
// //       title: "Provide Contact Details",
// //       subtitle:
// //           "Please provide your phone number and residential address. You can choose to provide proof of address now, or save it for a later upgrade.",
// //       step: 3,
// //       child: Column(
// //         children: [
// //           _buildTextField(
// //             label: "Phone Number",
// //             icon: FontAwesomeIcons.phone,
// //             keyboardType: TextInputType.phone,
// //           ),
// //           const SizedBox(height: 20),
// //           _buildTextField(
// //             label: "Residential Address",
// //             icon: FontAwesomeIcons.house,
// //           ),
// //           const SizedBox(height: 20),
// //           Container(
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: SwitchListTile(
// //               title: const Text("Upload Proof of Address now?"),
// //               value: _uploadProofNow,
// //               onChanged: (bool value) {
// //                 setState(() {
// //                   _uploadProofNow = value;
// //                 });
// //               },
// //               activeColor: const Color(0xFF4A90E2),
// //               contentPadding: const EdgeInsets.symmetric(
// //                 horizontal: 16,
// //                 vertical: 4,
// //               ),
// //             ),
// //           ),
// //           const Spacer(),
// //           _buildContinueButton(
// //             onPressed: () {
// //               // If _uploadProofNow is true, you could navigate to a file picker screen first.
// //               Navigator.push(
// //                 context,
// //                 PageTransition(
// //                   type: PageTransitionType.rightToLeft,
// //                   child: const SelfieLivenessScreen(),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // --- Scene 6: Selfie & Liveness Check ---
// // class SelfieLivenessScreen extends StatelessWidget {
// //   const SelfieLivenessScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return OnboardingStepScreen(
// //       title: "Confirm Your Liveness",
// //       subtitle:
// //           "Take a quick selfie. This helps us conduct a liveness check to ensure it's really you and compares it with your NIN image.",
// //       step: 4,
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Container(
// //             height: 250,
// //             width: 250,
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               border: Border.all(color: const Color(0xFF4A90E2), width: 4),
// //               color: Colors.grey[200],
// //             ),
// //             child: const Icon(
// //               FontAwesomeIcons.cameraRetro,
// //               size: 80,
// //               color: Color(0xFF4A90E2),
// //             ),
// //           ),
// //           const SizedBox(height: 30),
// //           Text(
// //             "Center your face in the frame",
// //             style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
// //           ),
// //           const Spacer(),
// //           _buildContinueButton(
// //             text: "Open Camera",
// //             onPressed: () {
// //               // In a real app, you would use the 'camera' package here.
// //               // For this simulation, we go straight to the next step.
// //               Navigator.push(
// //                 context,
// //                 PageTransition(
// //                   type: PageTransitionType.rightToLeft,
// //                   child: const SecurityCheckScreen(),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // --- Scene 7: Background Screening ---
// // class SecurityCheckScreen extends StatefulWidget {
// //   const SecurityCheckScreen({super.key});

// //   @override
// //   State<SecurityCheckScreen> createState() => _SecurityCheckScreenState();
// // }

// // class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.delayed(const Duration(seconds: 7), () {
// //       if (mounted) {
// //         Navigator.pushAndRemoveUntil(
// //           context,
// //           PageTransition(
// //             type: PageTransitionType.fade,
// //             child: const Tier2ActivationScreen(),
// //           ),
// //           (route) => false,
// //         );
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return OnboardingStepScreen(
// //       title: "Advanced Security Check",
// //       subtitle:
// //           "For your security and compliance, we conduct a robust background screening. This will only take a moment.",
// //       step: 5,
// //       child: const Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           SecurityCheckItem(
// //             icon: FontAwesomeIcons.magnifyingGlass,
// //             text: "Screening against Blacklists...",
// //             delay: Duration(seconds: 1),
// //           ),
// //           SizedBox(height: 30),
// //           SecurityCheckItem(
// //             icon: FontAwesomeIcons.shieldHalved,
// //             text: "Checking Politically Exposed Persons (PEP) lists...",
// //             delay: Duration(seconds: 3),
// //           ),
// //           SizedBox(height: 30),
// //           SecurityCheckItem(
// //             icon: FontAwesomeIcons.solidNewspaper,
// //             text: "Scanning for Adverse Media reports...",
// //             delay: Duration(seconds: 5),
// //           ),
// //           SizedBox(height: 40),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class SecurityCheckItem extends StatefulWidget {
// //   final String text;
// //   final Duration delay;
// //   final IconData icon;

// //   const SecurityCheckItem({
// //     super.key,
// //     required this.text,
// //     required this.delay,
// //     required this.icon,
// //   });

// //   @override
// //   State<SecurityCheckItem> createState() => _SecurityCheckItemState();
// // }

// // class _SecurityCheckItemState extends State<SecurityCheckItem> {
// //   bool _isChecking = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.delayed(widget.delay, () {
// //       if (mounted) {
// //         setState(() {
// //           _isChecking = false;
// //         });
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         AnimatedSwitcher(
// //           duration: const Duration(milliseconds: 500),
// //           transitionBuilder: (child, animation) =>
// //               ScaleTransition(scale: animation, child: child),
// //           child: _isChecking
// //               ? const SizedBox(
// //                   key: ValueKey('loader'),
// //                   width: 24,
// //                   height: 24,
// //                   child: CircularProgressIndicator(
// //                     strokeWidth: 3,
// //                     color: Color(0xFF4A90E2),
// //                   ),
// //                 )
// //               : Icon(
// //                   key: const ValueKey('check'),
// //                   widget.icon,
// //                   color: const Color(0xFF28a745),
// //                   size: 24,
// //                 ),
// //         ),
// //         const SizedBox(width: 20),
// //         Expanded(
// //           child: Text(
// //             widget.text,
// //             style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // --- Scene 3 & Intermediate Processing Screen ---
// // class ProcessingScreen extends StatefulWidget {
// //   final Widget nextScreen;

// //   const ProcessingScreen({super.key, required this.nextScreen});

// //   @override
// //   State<ProcessingScreen> createState() => _ProcessingScreenState();
// // }

// // class _ProcessingScreenState extends State<ProcessingScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.delayed(const Duration(seconds: 3), () {
// //       if (mounted) {
// //         Navigator.pushReplacement(
// //           context,
// //           PageTransition(
// //             type: PageTransitionType.fade,
// //             duration: const Duration(milliseconds: 500),
// //             child: SuccessScreen(nextScreen: widget.nextScreen),
// //           ),
// //         );
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Lottie.asset(
// //               'assets/lottie/processing.json', // Your Lottie file for processing
// //               width: 200,
// //               height: 200,
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               "Processing...",
// //               style: GoogleFonts.poppins(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             Text(
// //               "Creating your secure wallet.",
// //               style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // --- Success Screen ---
// // class SuccessScreen extends StatelessWidget {
// //   final Widget nextScreen;
// //   const SuccessScreen({super.key, required this.nextScreen});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(24.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             Lottie.asset(
// //               'assets/lottie/success.json', // Your Lottie file for success
// //               width: 150,
// //               height: 150,
// //               repeat: false,
// //             ),
// //             const SizedBox(height: 30),
// //             Text(
// //               "Success! Wallet Created.",
// //               textAlign: TextAlign.center,
// //               style: GoogleFonts.poppins(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             Card(
// //               elevation: 4,
// //               shadowColor: Colors.black.withOpacity(0.1),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(20.0),
// //                 child: Column(
// //                   children: [
// //                     _buildInfoRow("Account Holder:", "JOHN DOE"),
// //                     const Divider(height: 20, thickness: 1),
// //                     _buildInfoRow("Account Number:", "2345678901"),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 50),
// //             _buildContinueButton(
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   PageTransition(
// //                     type: PageTransitionType.rightToLeft,
// //                     child: nextScreen,
// //                   ),
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInfoRow(String label, String value) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           label,
// //           style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
// //         ),
// //         Text(
// //           value,
// //           style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // --- Scene 8: Tier 2 Account Activation ---
// // class Tier2ActivationScreen extends StatefulWidget {
// //   const Tier2ActivationScreen({super.key});

// //   @override
// //   State<Tier2ActivationScreen> createState() => _Tier2ActivationScreenState();
// // }

// // class _Tier2ActivationScreenState extends State<Tier2ActivationScreen> {
// //   late ConfettiController _confettiController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _confettiController = ConfettiController(
// //       duration: const Duration(seconds: 1),
// //     );
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _confettiController.play();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _confettiController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       alignment: Alignment.topCenter,
// //       children: [
// //         Scaffold(
// //           body: Padding(
// //             padding: const EdgeInsets.all(24.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 const Icon(
// //                   FontAwesomeIcons.award,
// //                   color: Color(0xFF4A90E2),
// //                   size: 100,
// //                 ),
// //                 const SizedBox(height: 30),
// //                 Text(
// //                   "Congratulations!",
// //                   textAlign: TextAlign.center,
// //                   style: GoogleFonts.poppins(
// //                     fontSize: 32,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Text(
// //                   "You've unlocked a Tier 2 Account.",
// //                   textAlign: TextAlign.center,
// //                   style: GoogleFonts.poppins(
// //                     fontSize: 18,
// //                     color: Colors.black54,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 40),
// //                 Container(
// //                   padding: const EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     border: Border.all(color: const Color(0xFF4A90E2)),
// //                     borderRadius: BorderRadius.circular(12),
// //                     color: const Color(0xFF4A90E2).withOpacity(0.05),
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                     children: [
// //                       _buildLimitInfo("Single Limit", "₦50,000"),
// //                       const SizedBox(
// //                         height: 50,
// //                         child: VerticalDivider(thickness: 1),
// //                       ),
// //                       _buildLimitInfo("Daily Limit", "₦200,000"),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 50),
// //                 _buildContinueButton(
// //                   text: "Start Transacting",
// //                   onPressed: () {
// //                     // Navigate to the app's home screen
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                         content: Text("Navigating to Home Screen!"),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //                 TextButton(
// //                   onPressed: () {
// //                     // In a real app, this would be in a settings/profile page
// //                     Navigator.push(
// //                       context,
// //                       PageTransition(
// //                         type: PageTransitionType.bottomToTop,
// //                         child: const Tier3UpgradeScreen(),
// //                       ),
// //                     );
// //                   },
// //                   child: Text(
// //                     "Upgrade to Tier 3 for higher limits",
// //                     style: GoogleFonts.poppins(
// //                       color: const Color(0xFF4A90E2),
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         ConfettiWidget(
// //           confettiController: _confettiController,
// //           blastDirection: -pi / 2,
// //           emissionFrequency: 0.05,
// //           numberOfParticles: 20,
// //           gravity: 0.1,
// //           shouldLoop: false,
// //           colors: const [
// //             Colors.green,
// //             Colors.blue,
// //             Colors.pink,
// //             Colors.orange,
// //             Colors.purple,
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildLimitInfo(String label, String value) {
// //     return Column(
// //       children: [
// //         Text(
// //           label,
// //           style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
// //         ),
// //         const SizedBox(height: 4),
// //         Text(
// //           value,
// //           style: GoogleFonts.poppins(
// //             fontSize: 18,
// //             fontWeight: FontWeight.bold,
// //             color: const Color(0xFF0A1128),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // --- Scene 9 & 10 (Combined into a single screen for KYC) ---
// // class Tier3UpgradeScreen extends StatelessWidget {
// //   const Tier3UpgradeScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           "Complete Your Profile",
// //           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //         backgroundColor: const Color(0xFFF7F8FC),
// //       ),
// //       body: ListView(
// //         padding: const EdgeInsets.all(24.0),
// //         children: [
// //           _buildSectionHeader(
// //             "Upgrade to Tier 3",
// //             "Unlock our highest transaction limits by providing a proof of address.",
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton.icon(
// //             style: ElevatedButton.styleFrom(
// //               padding: const EdgeInsets.symmetric(vertical: 16),
// //               backgroundColor: const Color(0xFF4A90E2).withOpacity(0.1),
// //               foregroundColor: const Color(0xFF4A90E2),
// //               elevation: 0,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //             ),
// //             onPressed: () {
// //               /* File picker logic here */
// //             },
// //             icon: const Icon(FontAwesomeIcons.fileArrowUp),
// //             label: const Text("Upload Proof of Address"),
// //           ),
// //           const SizedBox(height: 40),
// //           _buildSectionHeader(
// //             "Full KYC Details",
// //             "This helps us ensure the highest level of security and provide you with a tailored financial experience.",
// //           ),
// //           const SizedBox(height: 20),
// //           _buildTextField(
// //             label: "Next of Kin Name",
// //             icon: FontAwesomeIcons.userGroup,
// //           ),
// //           const SizedBox(height: 20),
// //           _buildTextField(
// //             label: "Next of Kin Phone",
// //             icon: FontAwesomeIcons.phone,
// //             keyboardType: TextInputType.phone,
// //           ),
// //           const SizedBox(height: 20),
// //           _buildTextField(
// //             label: "Source of Income",
// //             icon: FontAwesomeIcons.sackDollar,
// //           ),
// //           const SizedBox(height: 40),
// //           _buildContinueButton(
// //             text: "Save & Complete",
// //             onPressed: () => Navigator.pop(context),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSectionHeader(String title, String subtitle) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           title,
// //           style: GoogleFonts.poppins(
// //             fontSize: 22,
// //             fontWeight: FontWeight.bold,
// //             color: const Color(0xFF0A1128),
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           subtitle,
// //           style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // --- Reusable Widgets ---

// // Widget _buildTextField({
// //   required String label,
// //   required IconData icon,
// //   TextInputType keyboardType = TextInputType.text,
// // }) {
// //   return TextField(
// //     keyboardType: keyboardType,
// //     decoration: InputDecoration(
// //       labelText: label,
// //       labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
// //       prefixIcon: Icon(icon, color: const Color(0xFF4A90E2), size: 20),
// //       filled: true,
// //       fillColor: Colors.white,
// //       border: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(12),
// //         borderSide: BorderSide.none,
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(12),
// //         borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
// //       ),
// //     ),
// //   );
// // }

// // Widget _buildContinueButton({
// //   required VoidCallback onPressed,
// //   String text = "Continue",
// // }) {
// //   return ElevatedButton(
// //     onPressed: onPressed,
// //     style: ElevatedButton.styleFrom(
// //       backgroundColor: const Color(0xFF4A90E2),
// //       padding: const EdgeInsets.symmetric(vertical: 16),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       elevation: 5,
// //       shadowColor: const Color(0xFF4A90E2).withOpacity(0.4),
// //     ),
// //     child: Text(
// //       text,
// //       style: GoogleFonts.poppins(
// //         fontSize: 18,
// //         fontWeight: FontWeight.bold,
// //         color: Colors.white,
// //       ),
// //     ),
// //   );
// // }

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:ansvel/securitycheckscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:confetti/confetti.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart:async';
// import 'dart:math';
// import 'package:uuid/uuid.dart';
// import 'package:country_state_city_picker/country_state_city_picker.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_google_maps_webservices/places.dart';
// import 'package:geocoding/geocoding.dart' as geo;
// import 'package:url_launcher/url_launcher.dart';

// // --- Password Strength Enum ---
// enum PasswordStrength { Empty, Weak, Normal, Strong, VeryStrong }

// // --- App Entry Point ---
// void main() {
//   runApp(const AnsvelApp());
// }

// // --- DATA MODELS ---

// enum UserRole { Customer, Merchant, Driver, Admin }

// enum BusinessType { FoodVendor, Restaurant, Blog, Service }

// class AppUser {
//   final UserRole role;
//   final Set<BusinessType> businessTypes;
//   AppUser({required this.role, this.businessTypes = const {}});
// }

// enum AdActionType { WebLink, InAppPage }

// class AdSlide {
//   final String id;
//   final String imageUrl;
//   final String title;
//   final String subtitle;
//   final String buttonText;
//   final AdActionType actionType;
//   final String actionTarget;

//   AdSlide({
//     required this.id,
//     required this.imageUrl,
//     required this.title,
//     required this.subtitle,
//     required this.buttonText,
//     required this.actionType,
//     required this.actionTarget,
//   });
// }

// // --- MOCK SERVICES ---
// class AuthService extends ChangeNotifier {
//   AppUser _currentUser = AppUser(role: UserRole.Customer);
//   AppUser get currentUser => _currentUser;

//   void updateUser(AppUser user) {
//     _currentUser = user;
//     notifyListeners();
//   }

//   void setRole(UserRole role) {
//     _currentUser = AppUser(
//       role: role,
//       businessTypes: _currentUser.businessTypes,
//     );
//     notifyListeners();
//   }

//   void setBusinessTypes(Set<BusinessType> types) {
//     if (_currentUser.role == UserRole.Merchant) {
//       _currentUser = AppUser(role: UserRole.Merchant, businessTypes: types);
//       notifyListeners();
//     }
//   }
// }

// final AuthService authService = AuthService();
// const String kGoogleApiKey = "YOUR_GOOGLE_API_KEY";
// const Uuid uuid = Uuid();

// // --- Main App Widget ---
// class AnsvelApp extends StatelessWidget {
//   const AnsvelApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Ansvel',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: const Color(0xFFF7F8FC),
//         textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
//         useMaterial3: true,
//       ),
//       home: const WelcomeScreen(),
//     );
//   }
// }

// // --- ONBOARDING FLOW (UNCHANGED) ---
// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});
//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2500),
//     );
//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
//     );
//     _controller.forward();

//     Future.delayed(const Duration(seconds: 4), () {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           PageTransition(
//             type: PageTransitionType.fade,
//             child: const CreateAccountScreen(),
//           ),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A1128),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ScaleTransition(
//               scale: _scaleAnimation,
//               child: Image.asset('assets/images/ansvel_logo.png', width: 150),
//             ),
//             const SizedBox(height: 24),
//             FadeTransition(
//               opacity: _fadeAnimation,
//               child: Text(
//                 'Ansvel: Your Digital Wallet, Your Way.',
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // --- SUPER APP HOME PAGE (UPDATED WITH BACKGROUND) ---

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<AdSlide> _adSlides = [];
//   bool _isLoadingAds = true;

//   // Carousel controller instance
//   final CarouselController _controller = CarouselController();

//   final List<AdSlide> _sampleSlides = [
//     AdSlide(
//       id: '1',
//       imageUrl:
//           'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?q=80&w=2070&auto=format&fit=crop',
//       title: 'Seamless Payments',
//       subtitle: 'Send money to anyone, anywhere, instantly.',
//       buttonText: 'Learn More',
//       actionType: AdActionType.WebLink,
//       actionTarget: 'https://flutter.dev',
//     ),
//     AdSlide(
//       id: '2',
//       imageUrl:
//           'https://images.unsplash.com/photo-1593342371757-56e45b533a23?q=80&w=2070&auto=format&fit=crop',
//       title: 'Your Food Delivered',
//       subtitle: 'Order from your favorite local restaurants.',
//       buttonText: 'Order Now',
//       actionType: AdActionType.InAppPage,
//       actionTarget: 'food_page',
//     ),
//     AdSlide(
//       id: '3',
//       imageUrl:
//           'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=2069&auto=format&fit=crop',
//       title: 'Go Anywhere',
//       subtitle: 'Book a ride to your destination in minutes.',
//       buttonText: 'Book Ride',
//       actionType: AdActionType.InAppPage,
//       actionTarget: 'ride_page',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fetchAds();
//     authService.addListener(() => setState(() {}));
//   }

//   Future<void> _fetchAds() async {
//     await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
//     setState(() {
//       _adSlides = _sampleSlides;
//       _isLoadingAds = false;
//     });
//   }

//   final allServices = [
//     {
//       'id': 'user_management',
//       'label': 'User Management',
//       'icon': FontAwesomeIcons.usersCog,
//       'role': UserRole.Admin,
//     },
//     {
//       'id': 'system_health',
//       'label': 'System Health',
//       'icon': FontAwesomeIcons.heartPulse,
//       'role': UserRole.Admin,
//     },
//     {
//       'id': 'manage_ads',
//       'label': 'Manage Ads',
//       'icon': FontAwesomeIcons.ad,
//       'role': UserRole.Admin,
//     },
//     {
//       'id': 'manage_orders',
//       'label': 'Manage Orders',
//       'icon': FontAwesomeIcons.boxOpen,
//       'business': BusinessType.FoodVendor,
//     },
//     {
//       'id': 'manage_bookings',
//       'label': 'Manage Bookings',
//       'icon': FontAwesomeIcons.calendarCheck,
//       'business': BusinessType.Service,
//     },
//     {
//       'id': 'restaurant_portal',
//       'label': 'Restaurant Portal',
//       'icon': FontAwesomeIcons.utensils,
//       'business': BusinessType.Restaurant,
//     },
//     {
//       'id': 'write_article',
//       'label': 'Write Article',
//       'icon': FontAwesomeIcons.penToSquare,
//       'business': BusinessType.Blog,
//     },
//     {
//       'id': 'earnings',
//       'label': 'My Earnings',
//       'icon': FontAwesomeIcons.sackDollar,
//       'role': [UserRole.Merchant, UserRole.Driver],
//     },
//     {
//       'id': 'route_planner',
//       'label': 'Route Planner',
//       'icon': FontAwesomeIcons.mapLocationDot,
//       'role': UserRole.Driver,
//     },
//     {
//       'id': 'send_money',
//       'label': 'Send Money',
//       'icon': FontAwesomeIcons.paperPlane,
//     },
//     {
//       'id': 'pay_bills',
//       'label': 'Pay Bills',
//       'icon': FontAwesomeIcons.fileInvoiceDollar,
//     },
//     {
//       'id': 'mobile_topup',
//       'label': 'Mobile Top-up',
//       'icon': FontAwesomeIcons.mobileScreenButton,
//     },
//     {
//       'id': 'scan_to_pay',
//       'label': 'Scan to Pay',
//       'icon': FontAwesomeIcons.qrcode,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final user = authService.currentUser;

//     final adminApps = allServices
//         .where((s) => s['role'] == UserRole.Admin)
//         .map(
//           (s) => _ServiceButton(
//             id: s['id'] as String,
//             label: s['label'] as String,
//             icon: s['icon'] as IconData,
//           ),
//         )
//         .toList();

//     List<_ServiceButton> businessApps = [];
//     if ([
//       UserRole.Admin,
//       UserRole.Merchant,
//       UserRole.Driver,
//     ].contains(user.role)) {
//       for (var service in allServices) {
//         bool roleMatch = false;
//         if (service.containsKey('role')) {
//           final roles = service['role'];
//           if (roles is List) {
//             roleMatch = roles.contains(user.role);
//           } else {
//             roleMatch = roles == user.role;
//           }
//         }
//         bool businessMatch =
//             user.role == UserRole.Merchant &&
//             service.containsKey('business') &&
//             user.businessTypes.contains(service['business']);
//         if ((roleMatch || businessMatch) && service['role'] != UserRole.Admin) {
//           businessApps.add(
//             _ServiceButton(
//               id: service['id'] as String,
//               label: service['label'] as String,
//               icon: service['icon'] as IconData,
//             ),
//           );
//         }
//       }
//     }

//     final publicApps = allServices
//         .where((s) => !s.containsKey('role') && !s.containsKey('business'))
//         .map(
//           (s) => _ServiceButton(
//             id: s['id'] as String,
//             label: s['label'] as String,
//             icon: s['icon'] as IconData,
//           ),
//         )
//         .toList();

//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: const NetworkImage(
//             "https://www.freevector.com/uploads/vector/preview/28972/Geometric-Vector-Background.jpg",
//           ), // Using a placeholder URL for the pattern
//           fit: BoxFit.cover,
//           colorFilter: ColorFilter.mode(
//             Colors.black.withOpacity(0.6), // Adjust opacity for readability
//             BlendMode.darken,
//           ),
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors
//             .transparent, // Make scaffold transparent to see the background
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           foregroundColor: Colors.white,
//           title: const Text("Welcome to Ansvel"),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child: DropdownButton<UserRole>(
//                 value: user.role,
//                 dropdownColor: Colors.deepPurple,
//                 style: const TextStyle(color: Colors.white),
//                 underline: const SizedBox.shrink(),
//                 icon: const Icon(Icons.person, color: Colors.white),
//                 onChanged: (UserRole? newValue) {
//                   if (newValue != null) {
//                     if (newValue == UserRole.Merchant) {
//                       authService.updateUser(
//                         AppUser(
//                           role: newValue,
//                           businessTypes: BusinessType.values.toSet(),
//                         ),
//                       );
//                     } else {
//                       authService.updateUser(AppUser(role: newValue));
//                     }
//                   }
//                 },
//                 items: UserRole.values
//                     .map(
//                       (UserRole role) => DropdownMenuItem<UserRole>(
//                         value: role,
//                         child: Text(role.name),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//         body: ListView(
//           children: [
//             _isLoadingAds
//                 ? const Center(child: CircularProgressIndicator())
//                 : _AdCarousel(slides: _adSlides),
//             _buildSection(context, "Admin Tools", adminApps),
//             _buildSection(
//               context,
//               "Business & Partner Tools",
//               businessApps.toSet().toList(),
//             ),
//             _buildSection(context, "Services For You", publicApps),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(
//     BuildContext context,
//     String title,
//     List<Widget> children,
//   ) {
//     if (children.isEmpty) return const SizedBox.shrink();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Wrap(spacing: 10, runSpacing: 10, children: children),
//         ),
//         const SizedBox(height: 24),
//       ],
//     );
//   }
// }

// class _ServiceButton extends StatelessWidget {
//   final String id;
//   final String label;
//   final IconData icon;

//   const _ServiceButton({
//     required this.id,
//     required this.label,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: (MediaQuery.of(context).size.width / 4) - 12,
//       child: GestureDetector(
//         onTap: () {
//           if (id == 'manage_ads') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const AdManagementScreen(),
//               ),
//             );
//           } else {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text("Tapped on $label")));
//           }
//         },
//         child: Column(
//           children: [
//             AspectRatio(
//               aspectRatio: 1,
//               child: Card(
//                 elevation: 0,
//                 color: Colors.white.withOpacity(0.1),
//                 child: Icon(icon, color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 12, color: Colors.white70),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // --- All other screens and widgets remain unchanged below this line ---

// class CreateAccountScreen extends StatefulWidget {
//   const CreateAccountScreen({super.key});

//   @override
//   State<CreateAccountScreen> createState() => _CreateAccountScreenState();
// }

// class _CreateAccountScreenState extends State<CreateAccountScreen> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   // --- STATE FOR PASSWORD VISIBILITY ---
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   bool _isUsernameLengthValid = false;
//   bool _usernameHasNoSpaces = false;
//   bool _isUsernameCharsValid = false;

//   PasswordStrength _passwordStrength = PasswordStrength.Empty;
//   bool _passwordsMatch = false;

//   @override
//   void initState() {
//     super.initState();
//     _usernameController.addListener(_validateUsername);
//     _passwordController.addListener(_validatePassword);
//     _confirmPasswordController.addListener(_validatePassword);
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _validateUsername() {
//     final username = _usernameController.text;
//     final emailString = "$username@ansveluseremail.com";
//     final validCharsRegex = RegExp(r"^[a-zA-Z0-9._-]+$");
//     final emailRegex = RegExp(
//       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
//     );

//     setState(() {
//       _isUsernameLengthValid = username.length >= 6;
//       _usernameHasNoSpaces = !username.contains(' ');
//       _isUsernameCharsValid =
//           validCharsRegex.hasMatch(username) &&
//           emailRegex.hasMatch(emailString);
//     });
//   }

//   void _validatePassword() {
//     final password = _passwordController.text;
//     final confirmPassword = _confirmPasswordController.text;

//     setState(() {
//       _passwordsMatch = password.isNotEmpty && password == confirmPassword;
//       if (password.isEmpty) {
//         _passwordStrength = PasswordStrength.Empty;
//         return;
//       }
//       int score = 0;
//       if (password.length >= 8) score++;
//       if (RegExp(r'[A-Z]').hasMatch(password)) score++;
//       if (RegExp(r'[a-z]').hasMatch(password)) score++;
//       if (RegExp(r'[0-9]').hasMatch(password)) score++;
//       if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;

//       if (score < 2 || password.length < 8) {
//         _passwordStrength = PasswordStrength.Weak;
//       } else if (score == 2) {
//         _passwordStrength = PasswordStrength.Normal;
//       } else if (score == 3) {
//         _passwordStrength = PasswordStrength.Strong;
//       } else if (score >= 4) {
//         _passwordStrength = PasswordStrength.VeryStrong;
//       }
//     });
//   }

//   bool get _isFormValid {
//     return _isUsernameLengthValid &&
//         _usernameHasNoSpaces &&
//         _isUsernameCharsValid &&
//         _passwordsMatch &&
//         _passwordStrength != PasswordStrength.Weak;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Create Your Account",
//           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Set your username",
//               style: Theme.of(
//                 context,
//               ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "You can use your phone number or create a unique username.",
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _usernameController,
//               decoration: const InputDecoration(
//                 labelText: "Username or Phone Number",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(12)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ValidationRequirementWidget(
//               text: "At least 6 characters long",
//               isValid: _isUsernameLengthValid,
//             ),
//             ValidationRequirementWidget(
//               text: "No spaces allowed",
//               isValid: _usernameHasNoSpaces,
//             ),
//             ValidationRequirementWidget(
//               text: "Only letters, numbers, '.', '_', '-' are allowed",
//               isValid: _isUsernameCharsValid,
//             ),
//             const SizedBox(height: 32),

//             Text(
//               "Set a secure password",
//               style: Theme.of(
//                 context,
//               ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               obscureText: !_isPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 border: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(12)),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isPasswordVisible
//                         ? Icons.visibility_off
//                         : Icons.visibility,
//                   ),
//                   onPressed: () =>
//                       setState(() => _isPasswordVisible = !_isPasswordVisible),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             PasswordStrengthIndicator(strength: _passwordStrength),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: !_isConfirmPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: "Confirm Password",
//                 border: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(12)),
//                 ),
//                 errorText:
//                     (_confirmPasswordController.text.isNotEmpty &&
//                         !_passwordsMatch)
//                     ? "Passwords do not match"
//                     : null,
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isConfirmPasswordVisible
//                         ? Icons.visibility_off
//                         : Icons.visibility,
//                   ),
//                   onPressed: () => setState(
//                     () =>
//                         _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 style: FilledButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 onPressed: _isFormValid
//                     ? () {
//                         Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.rightToLeft,
//                             child: const BvnInputScreen(),
//                           ),
//                         );
//                       }
//                     : null,
//                 child: const Text(
//                   "Continue to Verification",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RoleSelectionScreen extends StatelessWidget {
//   const RoleSelectionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 "How will you be using Ansvel?",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 "Choose your primary role to get a personalized experience.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 40),
//               _RoleCard(
//                 icon: FontAwesomeIcons.user,
//                 title: "Customer",
//                 subtitle: "Send money, pay bills, and manage your finances.",
//                 onTap: () {
//                   authService.setRole(UserRole.Customer);
//                   Navigator.push(
//                     context,
//                     PageTransition(
//                       type: PageTransitionType.rightToLeft,
//                       child: const Tier2ActivationScreen(),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               _RoleCard(
//                 icon: FontAwesomeIcons.store,
//                 title: "Merchant",
//                 subtitle:
//                     "Sell goods or offer services on the Ansvel platform.",
//                 onTap: () {
//                   authService.setRole(UserRole.Merchant);
//                   Navigator.push(
//                     context,
//                     PageTransition(
//                       type: PageTransitionType.rightToLeft,
//                       child: const MerchantTypeSelectionScreen(),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               _RoleCard(
//                 icon: FontAwesomeIcons.motorcycle,
//                 title: "Driver",
//                 subtitle: "Provide delivery or ride-hailing services.",
//                 onTap: () {
//                   authService.setRole(UserRole.Driver);
//                   Navigator.push(
//                     context,
//                     PageTransition(
//                       type: PageTransitionType.rightToLeft,
//                       child: const Tier2ActivationScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _RoleCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;

//   const _RoleCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             children: [
//               Icon(
//                 icon,
//                 size: 32,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(subtitle, style: TextStyle(color: Colors.grey[600])),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios, color: Colors.grey),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MerchantTypeSelectionScreen extends StatefulWidget {
//   const MerchantTypeSelectionScreen({super.key});

//   @override
//   State<MerchantTypeSelectionScreen> createState() =>
//       _MerchantTypeSelectionScreenState();
// }

// class _MerchantTypeSelectionScreenState
//     extends State<MerchantTypeSelectionScreen> {
//   final Set<BusinessType> _selectedTypes = {};

//   void _toggleSelection(BusinessType type) {
//     setState(() {
//       if (_selectedTypes.contains(type)) {
//         _selectedTypes.remove(type);
//       } else {
//         _selectedTypes.add(type);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final businessOptions = {
//       BusinessType.FoodVendor: {
//         "label": "Food Vendor",
//         "icon": FontAwesomeIcons.bowlFood,
//       },
//       BusinessType.Restaurant: {
//         "label": "Run a restaurant",
//         "icon": FontAwesomeIcons.utensils,
//       },
//       BusinessType.Blog: {
//         "label": "Blog / Journalist",
//         "icon": FontAwesomeIcons.penNib,
//       },
//       BusinessType.Service: {
//         "label": "I offer a Service",
//         "icon": FontAwesomeIcons.handshake,
//       },
//     };

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Merchant Setup"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             Text(
//               "I would be conducting the following business on Ansvel",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "You can select more than one.",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 32),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 20,
//                   mainAxisSpacing: 20,
//                   childAspectRatio: 1,
//                 ),
//                 itemCount: businessOptions.length,
//                 itemBuilder: (context, index) {
//                   final type = businessOptions.keys.elementAt(index);
//                   final details = businessOptions[type]!;
//                   return _BusinessChoiceCard(
//                     label: details["label"] as String,
//                     icon: details["icon"] as IconData,
//                     isSelected: _selectedTypes.contains(type),
//                     onTap: () => _toggleSelection(type),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 style: FilledButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 onPressed: _selectedTypes.isNotEmpty
//                     ? () {
//                         authService.setBusinessTypes(_selectedTypes);
//                         Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.rightToLeft,
//                             child: const Tier2ActivationScreen(),
//                           ),
//                         );
//                       }
//                     : null,
//                 child: const Text(
//                   "Continue",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _BusinessChoiceCard extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _BusinessChoiceCard({
//     required this.label,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
//               : Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected
//                 ? Theme.of(context).colorScheme.primary
//                 : Colors.grey.shade300,
//             width: 2,
//           ),
//         ),
//         child: Stack(
//           children: [
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     icon,
//                     size: 40,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     label,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Icon(
//                   Icons.check_circle,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Tier2ActivationScreen extends StatefulWidget {
//   const Tier2ActivationScreen({super.key});
//   @override
//   State<Tier2ActivationScreen> createState() => _Tier2ActivationScreenState();
// }

// class _Tier2ActivationScreenState extends State<Tier2ActivationScreen> {
//   late ConfettiController _confettiController;
//   @override
//   void initState() {
//     super.initState();
//     _confettiController = ConfettiController(
//       duration: const Duration(seconds: 1),
//     );
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) => _confettiController.play(),
//     );
//   }

//   @override
//   void dispose() {
//     _confettiController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.topCenter,
//       children: [
//         Scaffold(
//           body: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Icon(
//                   FontAwesomeIcons.award,
//                   color: Theme.of(context).colorScheme.primary,
//                   size: 100,
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   "Congratulations!",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Your Tier 2 Account is Active!",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 FilledButton(
//                   style: FilledButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   onPressed: () {
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => const HomePage()),
//                       (route) => false,
//                     );
//                   },
//                   child: Text(
//                     "Start Transacting Now",
//                     style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 if (authService.currentUser.role != UserRole.Admin)
//                   const SizedBox(height: 16),
//                 if (authService.currentUser.role != UserRole.Admin)
//                   OutlinedButton.icon(
//                     icon: const Icon(FontAwesomeIcons.circleArrowUp),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CompleteKYCScreen(),
//                         ),
//                       );
//                     },
//                     label: Text(
//                       "Upgrade to Tier 3",
//                       style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//         ConfettiWidget(
//           confettiController: _confettiController,
//           blastDirection: -pi / 2,
//           emissionFrequency: 0.05,
//           numberOfParticles: 20,
//           gravity: 0.1,
//           shouldLoop: false,
//           colors: const [
//             Colors.green,
//             Colors.blue,
//             Colors.pink,
//             Colors.orange,
//             Colors.purple,
//           ],
//         ),
//       ],
//     );
//   }
// }

// class CompleteKYCScreen extends StatefulWidget {
//   const CompleteKYCScreen({super.key});
//   @override
//   State<CompleteKYCScreen> createState() => _CompleteKYCScreenState();
// }

// class _CompleteKYCScreenState extends State<CompleteKYCScreen> {
//   int _currentStep = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Upgrade to Tier 3",
//           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Stepper(
//         type: StepperType.vertical,
//         currentStep: _currentStep,
//         onStepContinue: () {
//           if (_currentStep < 4)
//             setState(() => _currentStep += 1);
//           else {
//             Navigator.pop(context);
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("Upgrade request submitted successfully!"),
//               ),
//             );
//           }
//         },
//         onStepCancel: () =>
//             _currentStep > 0 ? setState(() => _currentStep -= 1) : null,
//         onStepTapped: (step) => setState(() => _currentStep = step),
//         steps: [
//           _buildStep(
//             title: "Upload Proof of Address",
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 OutlinedButton.icon(
//                   icon: const Icon(FontAwesomeIcons.fileArrowUp),
//                   label: const Text("Upload Document"),
//                   onPressed: () {
//                     /* File picker logic would go here */
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Acceptable Documents:",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 8),
//                 const _AcceptableDocumentsList(),
//               ],
//             ),
//           ),
//           _buildStep(
//             title: "Personal Details",
//             content: Column(
//               children: [
//                 _buildDropdown("Gender", ["Male", "Female", "Other"]),
//                 _buildTextFormField(
//                   "Date of Birth",
//                   FontAwesomeIcons.calendar,
//                   isDate: true,
//                 ),
//                 _buildTextFormField("Place of Birth", FontAwesomeIcons.mapPin),
//                 _buildTextFormField(
//                   "Mother's Maiden Name",
//                   FontAwesomeIcons.personDress,
//                 ),
//                 _buildDropdown("Marital Status", [
//                   "Single",
//                   "Married",
//                   "Divorced",
//                 ]),
//               ],
//             ),
//           ),
//           _buildStep(
//             title: "Financial Profile",
//             content: Column(
//               children: [
//                 _buildDropdown("Source of Funds/Wealth", [
//                   "Salary",
//                   "Business",
//                   "Inheritance",
//                 ]),
//                 _buildDropdown("Employment Status", [
//                   "Employed",
//                   "Self-Employed",
//                   "Unemployed",
//                 ]),
//                 _buildTextFormField(
//                   "Employer's Name",
//                   FontAwesomeIcons.building,
//                 ),
//               ],
//             ),
//           ),
//           _buildStep(
//             title: "Next of Kin",
//             content: Column(
//               children: [
//                 _buildTextFormField("Full Name", FontAwesomeIcons.user),
//                 _buildTextFormField(
//                   "Phone Number",
//                   FontAwesomeIcons.phone,
//                   isNumber: true,
//                 ),
//               ],
//             ),
//           ),
//           _buildStep(
//             title: "Additional Information",
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Services Required",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const _ServiceSelection(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Step _buildStep({required String title, required Widget content}) => Step(
//     title: Text(title),
//     content: content,
//     isActive: _currentStep >= 0,
//     state: _currentStep > 0 ? StepState.complete : StepState.indexed,
//   );
//   Widget _buildTextFormField(
//     String label,
//     IconData icon, {
//     bool isDate = false,
//     bool isNumber = false,
//   }) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: TextFormField(
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, size: 20),
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//       ),
//       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//       readOnly: isDate,
//       onTap: isDate
//           ? () => showDatePicker(
//               context: context,
//               firstDate: DateTime(1900),
//               lastDate: DateTime.now(),
//             )
//           : null,
//     ),
//   );
//   Widget _buildDropdown(String label, List<String> items) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: DropdownButtonFormField(
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//       ),
//       items: items
//           .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//           .toList(),
//       onChanged: (value) {},
//     ),
//   );
// }

// class _AcceptableDocumentsList extends StatelessWidget {
//   const _AcceptableDocumentsList();

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       children: [
//         _DocumentItem(
//           text: "Utility Bill (e.g., PHCN, Water) not older than 3 months.",
//         ),
//         _DocumentItem(text: "Recent Bank Statement not older than 3 months."),
//         _DocumentItem(text: "Valid Tenancy Agreement or Rent Receipt."),
//         _DocumentItem(text: "Recent Tax Assessment or Clearance Certificate."),
//         _DocumentItem(
//           text: "National ID Card (NIN Slip) showing your address.",
//         ),
//         _DocumentItem(
//           text: "Letter from a recognized public official or employer.",
//         ),
//       ],
//     );
//   }
// }

// class _DocumentItem extends StatelessWidget {
//   final String text;
//   const _DocumentItem({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
//           const SizedBox(width: 8),
//           Expanded(child: Text(text)),
//         ],
//       ),
//     );
//   }
// }

// class _AdCarousel extends StatelessWidget {
//   final List<AdSlide> slides;
//   const _AdCarousel({required this.slides});

//   void _handleButtonPress(BuildContext context, AdSlide slide) async {
//     if (slide.actionType == AdActionType.WebLink) {
//       final uri = Uri.tryParse(slide.actionTarget);
//       if (uri != null && await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Could not open link: ${slide.actionTarget}")),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Navigating to in-app page: ${slide.actionTarget}"),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 200.0,
//         autoPlay: true,
//         enlargeCenterPage: true,
//         aspectRatio: 16 / 9,
//         viewportFraction: 0.9,
//       ),
//       items: slides.map((slide) {
//         return Builder(
//           builder: (BuildContext context) {
//             return Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.symmetric(horizontal: 5.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 image: DecorationImage(
//                   image: NetworkImage(slide.imageUrl),
//                   fit: BoxFit.cover,
//                   colorFilter: ColorFilter.mode(
//                     Colors.black.withOpacity(0.4),
//                     BlendMode.darken,
//                   ),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       slide.title,
//                       style: const TextStyle(
//                         fontSize: 22.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       slide.subtitle,
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                         color: Colors.white70,
//                       ),
//                     ),
//                     const Spacer(),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: FilledButton(
//                         onPressed: () => _handleButtonPress(context, slide),
//                         child: Text(slide.buttonText),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }
// }

// class AdManagementScreen extends StatefulWidget {
//   const AdManagementScreen({super.key});

//   @override
//   State<AdManagementScreen> createState() => _AdManagementScreenState();
// }

// class _AdManagementScreenState extends State<AdManagementScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _imageUrlController = TextEditingController();
//   final _titleController = TextEditingController();
//   final _subtitleController = TextEditingController();
//   final _buttonTextController = TextEditingController(text: 'Learn More');
//   final _actionTargetController = TextEditingController();
//   AdActionType _selectedActionType = AdActionType.WebLink;

//   Future<void> _publishAd() async {
//     if (_formKey.currentState!.validate()) {
//       final newAd = AdSlide(
//         id: uuid.v4(),
//         imageUrl: _imageUrlController.text,
//         title: _titleController.text,
//         subtitle: _subtitleController.text,
//         buttonText: _buttonTextController.text,
//         actionType: _selectedActionType,
//         actionTarget: _actionTargetController.text,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Ad published! (Offline Mode)"),
//           backgroundColor: Colors.green,
//         ),
//       );
//       _formKey.currentState!.reset();
//       _buttonTextController.text = 'Learn More';
//       FocusScope.of(context).unfocus();
//     }
//   }

//   @override
//   void dispose() {
//     _imageUrlController.dispose();
//     _titleController.dispose();
//     _subtitleController.dispose();
//     _buttonTextController.dispose();
//     _actionTargetController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Ad Management")),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           Text(
//             "Create New Ad",
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           const SizedBox(height: 16),
//           Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _imageUrlController,
//                   decoration: const InputDecoration(
//                     labelText: 'Background Image URL',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) => v!.isEmpty ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(
//                     labelText: 'Title',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) => v!.isEmpty ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _subtitleController,
//                   decoration: const InputDecoration(
//                     labelText: 'Subtitle',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) => v!.isEmpty ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _buttonTextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Button Text',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) => v!.isEmpty ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 12),
//                 DropdownButtonFormField<AdActionType>(
//                   value: _selectedActionType,
//                   decoration: const InputDecoration(
//                     labelText: 'Action Type',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: AdActionType.values
//                       .map(
//                         (type) => DropdownMenuItem(
//                           value: type,
//                           child: Text(type.name),
//                         ),
//                       )
//                       .toList(),
//                   onChanged: (v) => setState(() => _selectedActionType = v!),
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _actionTargetController,
//                   decoration: InputDecoration(
//                     labelText: _selectedActionType == AdActionType.WebLink
//                         ? 'Web URL'
//                         : 'In-App Page Name',
//                     border: const OutlineInputBorder(),
//                   ),
//                   validator: (v) => v!.isEmpty ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: FilledButton.icon(
//                     onPressed: _publishAd,
//                     icon: const Icon(Icons.publish),
//                     label: const Text("Publish Ad"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SecurityCheckItem extends StatefulWidget {
//   final String text;
//   final Duration delay;
//   const SecurityCheckItem({super.key, required this.text, required this.delay});
//   @override
//   State<SecurityCheckItem> createState() => _SecurityCheckItemState();
// }

// class _SecurityCheckItemState extends State<SecurityCheckItem> {
//   bool _isChecking = true;
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(
//       widget.delay,
//       () => {if (mounted) setState(() => _isChecking = false)},
//     );
//   }

//   @override
//   Widget build(BuildContext context) => Row(
//     children: [
//       AnimatedSwitcher(
//         duration: const Duration(milliseconds: 500),
//         transitionBuilder: (child, animation) =>
//             ScaleTransition(scale: animation, child: child),
//         child: _isChecking
//             ? SizedBox(
//                 key: const ValueKey('loader'),
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               )
//             : Icon(
//                 key: const ValueKey('check'),
//                 FontAwesomeIcons.solidCircleCheck,
//                 color: Colors.green,
//                 size: 24,
//               ),
//       ),
//       const SizedBox(width: 20),
//       Expanded(
//         child: Text(
//           widget.text,
//           style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
//         ),
//       ),
//     ],
//   );
// }

// class ValidationRequirementWidget extends StatelessWidget {
//   final String text;
//   final bool isValid;
//   const ValidationRequirementWidget({
//     super.key,
//     required this.text,
//     required this.isValid,
//   });
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4.0),
//     child: Row(
//       children: [
//         Icon(
//           isValid ? Icons.check_circle : Icons.cancel,
//           color: isValid ? Colors.green : Colors.red,
//           size: 20,
//         ),
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: TextStyle(color: isValid ? Colors.grey[700] : Colors.red),
//         ),
//       ],
//     ),
//   );
// }

// class PasswordStrengthIndicator extends StatelessWidget {
//   final PasswordStrength strength;
//   const PasswordStrengthIndicator({super.key, required this.strength});
//   @override
//   Widget build(BuildContext context) {
//     String text = "Weak";
//     Color color = Colors.red;
//     double value = 0.2;
//     switch (strength) {
//       case PasswordStrength.Empty:
//         text = "";
//         value = 0.0;
//         break;
//       case PasswordStrength.Weak:
//         text = "Weak";
//         color = Colors.red;
//         value = 0.25;
//         break;
//       case PasswordStrength.Normal:
//         text = "Normal";
//         color = Colors.orange;
//         value = 0.5;
//         break;
//       case PasswordStrength.Strong:
//         text = "Strong";
//         color = Colors.blue;
//         value = 0.75;
//         break;
//       case PasswordStrength.VeryStrong:
//         text = "Very Strong";
//         color = Colors.green;
//         value = 1.0;
//         break;
//     }
//     if (strength == PasswordStrength.Empty) return const SizedBox.shrink();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LinearProgressIndicator(
//           value: value,
//           backgroundColor: Colors.grey[300],
//           color: color,
//           minHeight: 6,
//         ),
//         const SizedBox(height: 4),
//         Text(
//           text,
//           style: TextStyle(color: color, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }

// class _ServiceSelection extends StatefulWidget {
//   const _ServiceSelection();
//   @override
//   State<_ServiceSelection> createState() => _ServiceSelectionState();
// }

// class _ServiceSelectionState extends State<_ServiceSelection> {
//   final Map<String, bool> _services = {
//     'ATM Card': false,
//     'Mobile Banking': true,
//     'Internet Banking': false,
//     'Transaction Alerts': true,
//   };
//   @override
//   Widget build(BuildContext context) => Column(
//     children: _services.keys
//         .map(
//           (String key) => CheckboxListTile(
//             title: Text(key),
//             value: _services[key],
//             onChanged: (bool? value) => setState(() => _services[key] = value!),
//           ),
//         )
//         .toList(),
//   );
// }

// class MapPickerScreen extends StatefulWidget {
//   final Function(double, double) onLocationSelected;
//   const MapPickerScreen({super.key, required this.onLocationSelected});
//   @override
//   State<MapPickerScreen> createState() => _MapPickerScreenState();
// }

// class _MapPickerScreenState extends State<MapPickerScreen> {
//   final LatLng _initialPosition = const LatLng(6.5244, 3.3792);
//   late LatLng _markerPosition = _initialPosition;
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(title: const Text("Select Your Address")),
//     body: Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: _initialPosition,
//             zoom: 15,
//           ),
//           onCameraMove: (position) =>
//               setState(() => _markerPosition = position.target),
//         ),
//         const Center(
//           child: Icon(Icons.location_pin, color: Colors.red, size: 50),
//         ),
//         Positioned(
//           bottom: 20,
//           left: 20,
//           right: 20,
//           child: FilledButton.icon(
//             icon: const Icon(Icons.check),
//             label: const Text("Confirm Location"),
//             onPressed: () {
//               widget.onLocationSelected(
//                 _markerPosition.latitude,
//                 _markerPosition.longitude,
//               );
//               Navigator.pop(context);
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }

// class OnboardingStepScreen extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final int step;
//   final int totalSteps;
//   final Widget child;

//   const OnboardingStepScreen({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.step,
//     required this.totalSteps,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Step $step of $totalSteps',
//               style: GoogleFonts.poppins(
//                 color: Theme.of(context).colorScheme.primary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: GoogleFonts.poppins(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF0A1128),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               subtitle,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Colors.black54,
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 40),
//             Expanded(child: child),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BvnInputScreen extends StatelessWidget {
//   const BvnInputScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return OnboardingStepScreen(
//       title: "Secure Your Wallet",
//       subtitle: "Start with your Bank Verification Number (BVN).",
//       step: 1,
//       totalSteps: 6,
//       child: Column(
//         children: [
//           TextField(
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               labelText: "Enter your 11-digit BVN",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(12)),
//               ),
//             ),
//           ),
//           const Spacer(),
//           SizedBox(
//             width: double.infinity,
//             child: FilledButton(
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               onPressed: () => Navigator.push(
//                 context,
//                 PageTransition(
//                   type: PageTransitionType.rightToLeft,
//                   child: const ProcessingScreen(
//                     nextScreen: NinInputScreen(),
//                     title: "Creating Your Wallet...",
//                   ),
//                 ),
//               ),
//               child: const Text(
//                 "Continue",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NinInputScreen extends StatelessWidget {
//   const NinInputScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return OnboardingStepScreen(
//       title: "Verify Your Identity",
//       subtitle: "Next, we need your National Identification Number (NIN).",
//       step: 2,
//       totalSteps: 6,
//       child: Column(
//         children: [
//           TextField(
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               labelText: "Enter your NIN",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(12)),
//               ),
//             ),
//           ),
//           const Spacer(),
//           SizedBox(
//             width: double.infinity,
//             child: FilledButton(
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               onPressed: () => Navigator.push(
//                 context,
//                 PageTransition(
//                   type: PageTransitionType.rightToLeft,
//                   child: const ContactInfoScreen(),
//                 ),
//               ),
//               child: const Text(
//                 "Continue",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ContactInfoScreen extends StatelessWidget {
//   const ContactInfoScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingStepScreen(
//       title: "Provide Contact Details",
//       subtitle: "Please provide your active phone number.",
//       step: 3,
//       totalSteps: 6,
//       child: Column(
//         children: [
//           const TextField(
//             decoration: InputDecoration(
//               labelText: "Phone Number",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(12)),
//               ),
//             ),
//           ),
//           const Spacer(),
//           SizedBox(
//             width: double.infinity,
//             child: FilledButton(
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               onPressed: () => Navigator.push(
//                 context,
//                 PageTransition(
//                   type: PageTransitionType.rightToLeft,
//                   child: const AddressCollectionScreen(),
//                 ),
//               ),
//               child: const Text(
//                 "Continue",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AddressCollectionScreen extends StatefulWidget {
//   const AddressCollectionScreen({super.key});

//   @override
//   State<AddressCollectionScreen> createState() =>
//       _AddressCollectionScreenState();
// }

// class _AddressCollectionScreenState extends State<AddressCollectionScreen> {
//   final _manualAddressController = TextEditingController();
//   final _searchController = SearchController();
//   late GoogleMapsPlaces _places;
//   String? _sessionToken;

//   @override
//   void initState() {
//     super.initState();
//     _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
//   }

//   void _startSearchSession() => _sessionToken = uuid.v4();

//   Future<void> _getPlaceDetail(String placeId) async {
//     final response = await _places.getDetailsByPlaceId(
//       placeId,
//       sessionToken: _sessionToken,
//     );
//     _sessionToken = null; // Session token is used once
//     if (response.isOkay) {
//       setState(
//         () => _manualAddressController.text =
//             response.result.formattedAddress ?? '',
//       );
//     }
//   }

//   void _openMapPicker() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MapPickerScreen(
//           onLocationSelected: (lat, lng) async {
//             List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
//               lat,
//               lng,
//             );
//             if (placemarks.isNotEmpty) {
//               final p = placemarks.first;
//               setState(
//                 () => _manualAddressController.text =
//                     "${p.street}, ${p.locality}, ${p.administrativeArea}",
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return OnboardingStepScreen(
//       title: "Residential Address",
//       subtitle: "Please provide your current home address.",
//       step: 4,
//       totalSteps: 6,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             SearchAnchor(
//               searchController: _searchController,
//               builder: (BuildContext context, SearchController controller) =>
//                   SearchBar(
//                     controller: controller,
//                     padding: const MaterialStatePropertyAll<EdgeInsets>(
//                       EdgeInsets.symmetric(horizontal: 16.0),
//                     ),
//                     onTap: () {
//                       _startSearchSession();
//                       controller.openView();
//                     },
//                     onChanged: (_) {
//                       if (!controller.isOpen) {
//                         _startSearchSession();
//                         controller.openView();
//                       }
//                     },
//                     leading: const Icon(Icons.search),
//                     hintText: "Search for your address...",
//                   ),
//               suggestionsBuilder:
//                   (BuildContext context, SearchController controller) async {
//                     if (controller.text.isEmpty)
//                       return [
//                         const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Text('Start typing an address...'),
//                         ),
//                       ];
//                     final response = await _places.autocomplete(
//                       controller.text,
//                       sessionToken: _sessionToken,
//                       components: [Component(Component.country, "ng")],
//                     );
//                     if (!response.isOkay)
//                       return [
//                         const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Text('Something went wrong.'),
//                         ),
//                       ];
//                     return response.predictions
//                         .map(
//                           (p) => ListTile(
//                             title: Text(p.description ?? ''),
//                             onTap: () {
//                               controller.closeView(p.description);
//                               _getPlaceDetail(p.placeId!);
//                             },
//                           ),
//                         )
//                         .toList();
//                   },
//             ),
//             const SizedBox(height: 10),
//             Center(
//               child: OutlinedButton.icon(
//                 icon: const Icon(FontAwesomeIcons.mapLocationDot),
//                 label: const Text("Select on Map"),
//                 onPressed: _openMapPicker,
//               ),
//             ),
//             const SizedBox(height: 15),
//             const Text(
//               "Or Enter Manually",
//               style: TextStyle(color: Colors.grey),
//             ),
//             const Divider(),
//             TextFormField(
//               controller: _manualAddressController,
//               decoration: const InputDecoration(
//                 labelText: "Street Address",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(12)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 style: FilledButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 onPressed: () => Navigator.push(
//                   context,
//                   PageTransition(
//                     type: PageTransitionType.rightToLeft,
//                     child: const SelfieLivenessScreen(),
//                   ),
//                 ),
//                 child: const Text(
//                   "Continue",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SelfieLivenessScreen extends StatelessWidget {
//   const SelfieLivenessScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingStepScreen(
//       title: "Confirm Your Liveness",
//       subtitle: "Take a quick selfie. This helps us ensure it's really you.",
//       step: 5,
//       totalSteps: 6,
//       child: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: Icon(
//                 FontAwesomeIcons.cameraRetro,
//                 size: 100,
//                 color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: double.infinity,
//             child: FilledButton(
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               onPressed: () => Navigator.push(
//                 context,
//                 PageTransition(
//                   type: PageTransitionType.rightToLeft,
//                   child: const SecurityCheckScreen(),
//                 ),
//               ),
//               child: const Text(
//                 "Open Camera",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProcessingScreen extends StatefulWidget {
//   final Widget nextScreen;
//   final String title;
//   const ProcessingScreen({
//     super.key,
//     required this.nextScreen,
//     required this.title,
//   });
//   @override
//   State<ProcessingScreen> createState() => _ProcessingScreenState();
// }

// class _ProcessingScreenState extends State<ProcessingScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted)
//         Navigator.pushReplacement(
//           context,
//           PageTransition(
//             type: PageTransitionType.fade,
//             duration: const Duration(milliseconds: 500),
//             child: SuccessScreen(nextScreen: widget.nextScreen),
//           ),
//         );
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Lottie.asset(
//             'assets/lottie/processing.json',
//             width: 200,
//             height: 200,
//           ),
//           const SizedBox(height: 20),
//           Text(
//             widget.title,
//             style: GoogleFonts.poppins(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// class SuccessScreen extends StatelessWidget {
//   final Widget nextScreen;
//   const SuccessScreen({super.key, required this.nextScreen});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Lottie.asset(
//             'assets/lottie/success.json',
//             width: 150,
//             height: 150,
//             repeat: false,
//           ),
//           const SizedBox(height: 30),
//           Text(
//             "Success! Wallet Created.",
//             textAlign: TextAlign.center,
//             style: GoogleFonts.poppins(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Card(
//             elevation: 4,
//             shadowColor: Colors.black.withOpacity(0.1),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Account Holder:",
//                         style: GoogleFonts.poppins(
//                           color: Colors.grey[600],
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         "JOHN DOE",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(height: 20, thickness: 1),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Account Number:",
//                         style: GoogleFonts.poppins(
//                           color: Colors.grey[600],
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         "2345678901",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 50),
//           FilledButton(
//             style: FilledButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//             ),
//             onPressed: () => Navigator.push(
//               context,
//               PageTransition(
//                 type: PageTransitionType.rightToLeft,
//                 child: nextScreen,
//               ),
//             ),
//             child: const Text(
//               "Continue",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
