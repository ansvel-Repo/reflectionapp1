// lib/views/wallet/add_wallet_screen.dart

import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/services/crypto_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/result_dialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key});

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBankName;
  String? _selectedCountry = 'Nigeria';
  final _pinController = TextEditingController();
  bool _isLoading = false;

  late Future<List<QueryDocumentSnapshot>> _banksFuture;

  @override
  void initState() {
    super.initState();
    _banksFuture = _fetchBanks();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<List<QueryDocumentSnapshot>> _fetchBanks() {
    return FirebaseFirestore.instance
        .collection('bankWallet')
        .where('Country', isEqualTo: _selectedCountry)
        .get()
        .then((snapshot) => snapshot.docs);
  }

  Future<void> _submitCreateWallet() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedBankName == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a bank.")),
          );
        }
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );
        final apiService = WalletApiService();
        final cryptoService = CryptoService();

        final encryptedPin = await cryptoService.encrypt(_pinController.text);
        if (encryptedPin == null) throw Exception("Could not encrypt PIN.");

        final user = authController.currentUser!;
        
        await apiService.createWallet(
          provider: _selectedBankName!.toLowerCase(),
          bvn: user.bvn!,
          dob: user.dateOfBirth!,
          country: _selectedCountry!,
          firstName: user.firstName!,
          lastName: user.lastName!,
          phoneNumber: user.phoneNumber!,
          address: user.address!,
          encryptedPin: encryptedPin,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("New wallet created successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => ResultDialog(
              isSuccess: false,
              title: "Creation Failed",
              message: e.toString().replaceFirst("Exception: ", ""),
              onDone: () => Navigator.of(context).pop(),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Wallet",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select a Bank",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<QueryDocumentSnapshot>>(
                future: _banksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No banks available for this country.");
                  }

                  final banks = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedBankName,
                    hint: const Text("Choose a wallet provider"),
                    items: banks.map((doc) {
                      final bank = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: bank["Bankname"],
                        child: Text(bank["Bankname"]),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedBankName = value),
                    validator: (v) => v == null ? 'Please select a bank' : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                "Create a 4-Digit PIN for this Wallet",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Center(
                child: Pinput(
                  length: 4,
                  controller: _pinController,
                  obscureText: true,
                  validator: (v) =>
                      v!.length != 4 ? 'PIN must be 4 digits' : null,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submitCreateWallet,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Create Wallet"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}