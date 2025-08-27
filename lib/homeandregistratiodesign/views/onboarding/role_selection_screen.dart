// import 'package:ansvel/controllers/auth_controller.dart';
// import 'package:ansvel/models/app_user.dart';
// import 'package:ansvel/views/onboarding/15_merchant_type_screen.dart';
// import 'package:ansvel/views/onboarding/16_tier2_activation_screen.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/app_user.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/merchant_type_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/tier2_activation_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("How will you be using Ansvel?", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text("Choose your primary role to get a personalized experience.", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 40),
              _RoleCard(
                icon: FontAwesomeIcons.user,
                title: "Customer",
                subtitle: "Send money, pay bills, and manage your finances.",
                onTap: () {
                  auth.setRole(UserRole.Customer);
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const Tier2ActivationScreen()));
                },
              ),
              const SizedBox(height: 20),
              _RoleCard(
                icon: FontAwesomeIcons.store,
                title: "Merchant",
                subtitle: "Sell goods or offer services on the Ansvel platform.",
                onTap: () {
                  auth.setRole(UserRole.Merchant);
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const MerchantTypeSelectionScreen()));
                },
              ),
              const SizedBox(height: 20),
              _RoleCard(
                icon: FontAwesomeIcons.motorcycle,
                title: "Driver",
                subtitle: "Provide delivery or ride-hailing services.",
                onTap: () {
                  auth.setRole(UserRole.Driver);
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const Tier2ActivationScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}