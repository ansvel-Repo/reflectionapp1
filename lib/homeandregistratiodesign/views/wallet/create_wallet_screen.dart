// import 'package:ansvel/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateWalletScreen extends StatefulWidget {
  const CreateWalletScreen({super.key});

  @override
  State<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bvnController = TextEditingController();
  final _dobController = TextEditingController();
  String? _selectedCountry = 'Nigeria';
  bool _isLoading = false;

  Future<void> _submitCreateWallet() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });
      try {
        final apiService = WalletApiService();
        // This method needs all required fields from the API
        // await apiService.createWallet(...);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wallet created successfully!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create New Wallet", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                items: ['Nigeria', 'Ghana', 'Kenya'].map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() { _selectedCountry = newValue; });
                },
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bvnController,
                decoration: const InputDecoration(labelText: "Bank Verification Number (BVN)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter your BVN' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: "Date of Birth (YYYY-MM-DD)"),
                validator: (value) => value!.isEmpty ? 'Please enter your date of birth' : null,
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