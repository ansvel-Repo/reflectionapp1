import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/onboarding_controller.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/processing_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/result_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class CreateWalletSummaryScreen extends StatefulWidget {
  const CreateWalletSummaryScreen({super.key});

  @override
  State<CreateWalletSummaryScreen> createState() =>
      _CreateWalletSummaryScreenState();
}

class _CreateWalletSummaryScreenState extends State<CreateWalletSummaryScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // It's better to get providers outside the build method if they don't need to be rebuilt on change
    final onboardingController = Provider.of<OnboardingController>(
      context,
      listen: false,
    );
    final authController = Provider.of<AuthController>(context, listen: false);
    final data = onboardingController.data;

    Future<void> _createWallet() async {
      setState(() {
        _isLoading = true;
      });
      final apiService = WalletApiService();
      try {
        // FIX: The method was renamed from 'createWallet' to 'createInitialWallet'
        final result = await apiService.createInitialWallet(
          bvn: data.bvn!,
          dob: data.dateOfBirth!,
          firstName: data.firstName!,
          lastName: data.lastName!,
          phoneNumber: data.phoneNumber!,
          address: data.address!,
          country: "Nigeria", // This can be made dynamic later
        );

        final walletData = result['wallet'];
        Map<String, dynamic> kycPayload = {
          'nin': data.nin,
          'firstName': data.firstName,
          'lastName': data.lastName,
          'dateOfBirth': data.dateOfBirth,
          'phoneNumber': data.phoneNumber,
          'gender': data.gender,
          'address': data.address,
          'bvn': data.bvn,
          'wallets': {
            'providus': {
              'accountNumber': walletData['accountNumber'],
              'accountName': walletData['accountName'],
              'bankName': walletData['bankName'],
              'status': walletData['status'],
              'country': 'Nigeria',
            },
          },
        };

        // Handle name mismatch by overwriting names in the payload
        if (result['customer']['nameMatch'] == false) {
          kycPayload['firstName'] = result['customer']['BVNFirstName'];
          kycPayload['lastName'] = result['customer']['BVNLastName'];
        }

        await authController.updateUserKYCData(kycPayload);

        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ResultDialog(
            isSuccess: true,
            title: "Wallet Created!",
            message: "Your ${walletData['bankName']} wallet is ready.",
            details: {
              "Account Name": walletData['accountName'],
              "Account Number": walletData['accountNumber'],
              "Status": walletData['status'],
            },
            onDone: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProcessingScreen()),
              );
            },
          ),
        );
      } catch (e) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => ResultDialog(
            isSuccess: false,
            title: "Creation Failed",
            message: e.toString().replaceFirst("Exception: ", ""),
            onDone: () => Navigator.of(context).pop(),
          ),
        );
      } finally {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirm Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Please confirm your details below before creating your wallet.",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                elevation: 0,
                color: Colors.white,
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text("Full Name"),
                      subtitle: Text("${data.firstName} ${data.lastName}"),
                    ),
                    ListTile(
                      title: const Text("Phone Number"),
                      subtitle: Text(data.phoneNumber ?? ''),
                    ),
                    ListTile(
                      title: const Text("Address"),
                      subtitle: Text(data.address ?? ''),
                    ),
                    ListTile(
                      title: const Text("BVN"),
                      subtitle: Text(data.bvn ?? ''),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _createWallet,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Create My Wallet"),
            ),
          ],
        ),
      ),
    );
  }
}
