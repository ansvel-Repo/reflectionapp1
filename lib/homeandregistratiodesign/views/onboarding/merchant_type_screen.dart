// import 'package:ansvel/controllers/auth_controller.dart';
// import 'package:ansvel/models/app_user.dart';
// import 'package:ansvel/views/onboarding/16_tier2_activation_screen.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/app_user.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/tier2_activation_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';


class MerchantTypeSelectionScreen extends StatefulWidget {
  const MerchantTypeSelectionScreen({super.key});

  @override
  State<MerchantTypeSelectionScreen> createState() => _MerchantTypeSelectionScreenState();
}

class _MerchantTypeSelectionScreenState extends State<MerchantTypeSelectionScreen> {
  final Set<BusinessType> _selectedTypes = {};

  void _toggleSelection(BusinessType type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);
    // Added the new business options to this map
    final businessOptions = {
      BusinessType.FoodVendor: {"label": "Food Vendor", "icon": FontAwesomeIcons.bowlFood},
      BusinessType.Restaurant: {"label": "Run a restaurant", "icon": FontAwesomeIcons.utensils},
      BusinessType.Blog: {"label": "Blog / Journalist", "icon": FontAwesomeIcons.penNib},
      BusinessType.Service: {"label": "I offer a Service", "icon": FontAwesomeIcons.handshake},
      BusinessType.RideSharing: {"label": "Ride-sharing, \nOffer free seats in your car for a fee", "icon": FontAwesomeIcons.carSide},
      BusinessType.RideHailing: {"label": "Ride-hailing, \nDedicated taxi serice", "icon": FontAwesomeIcons.taxi},
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Merchant Setup"), backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("I would be conducting the following business on Ansvel", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("You can select more than one.", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 1),
                itemCount: businessOptions.length,
                itemBuilder: (context, index) {
                  final type = businessOptions.keys.elementAt(index);
                  final details = businessOptions[type]!;
                  return _BusinessChoiceCard(
                    label: details["label"] as String,
                    icon: details["icon"] as IconData,
                    isSelected: _selectedTypes.contains(type),
                    onTap: () => _toggleSelection(type),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selectedTypes.isNotEmpty
                    ? () {
                        auth.setBusinessTypes(_selectedTypes);
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const Tier2ActivationScreen()));
                      }
                    : null,
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessChoiceCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BusinessChoiceCard({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300, width: 2),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
              ),
          ],
        ),
      ),
    );
  }
}