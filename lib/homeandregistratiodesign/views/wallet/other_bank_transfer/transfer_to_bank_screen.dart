// import 'package:ansvel/widgets/pin_entry_dialog.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/transfer_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/other_bank_transfer/transfer_summary_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/pin_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TransferToBankScreen extends StatefulWidget {
  final Wallet sourceWallet;
  const TransferToBankScreen({super.key, required this.sourceWallet});

  @override
  State<TransferToBankScreen> createState() => _TransferToBankScreenState();
}

class _TransferToBankScreenState extends State<TransferToBankScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _narrationController = TextEditingController();

  Map<String, dynamic>? _selectedBank;

  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to safely access the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transferController = Provider.of<TransferController>(
        context,
        listen: false,
      );
      transferController.fetchBankList(widget.sourceWallet.country ?? '');

      _accountController.addListener(() {
        if (_accountController.text.length == 10) {
          if (_selectedBank != null) {
            transferController.verifyAccountNumber(
              _accountController.text,
              _selectedBank!['code'],
            );
          }
        } else {
          transferController.clearVerification();
        }
      });
    });
  }

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _narrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransferController(),
      child: Consumer<TransferController>(
        builder: (context, controller, child) {
          if (controller.verificationError != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(controller.verificationError!),
                  backgroundColor: Colors.red,
                ),
              );
              controller.clearVerification();
            });
          }

          bool isFormComplete =
              _selectedBank != null &&
              controller.verifiedAccountName != null &&
              _amountController.text.isNotEmpty;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Transfer to Bank",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Bank Selection
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedBank,
                      isExpanded: true,
                      hint: controller.isFetchingBanks
                          ? const Text("Loading Banks...")
                          : const Text("Select Destination Bank"),
                      items: controller.banks.map((bank) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: bank,
                          child: Text(bank["name"]!),
                        );
                      }).toList(),
                      onChanged: controller.isFetchingBanks
                          ? null
                          : (value) {
                              setState(() => _selectedBank = value);
                              if (_accountController.text.length == 10) {
                                controller.verifyAccountNumber(
                                  _accountController.text,
                                  _selectedBank!['code'],
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 20),
                    // Account Number
                    TextFormField(
                      controller: _accountController,
                      decoration: InputDecoration(
                        labelText: "Account Number",
                        counterText: "",
                        suffix: controller.isVerifyingAccount
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    // Verified Account Name
                    if (controller.verifiedAccountName != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.verifiedAccountName!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    // Amount and Narration (enabled only after verification)
                    TextFormField(
                      controller: _amountController,
                      enabled: controller.verifiedAccountName != null,
                      decoration: const InputDecoration(
                        labelText: "Amount (₦)",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _narrationController,
                      enabled: controller.verifiedAccountName != null,
                      decoration: const InputDecoration(
                        labelText: "Narration (Optional)",
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isFormComplete
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TransferSummaryScreen(
                                      fromWallet: widget.sourceWallet,
                                      bankName: _selectedBank!['name'],
                                      bankCode: _selectedBank!['code'],
                                      accountName:
                                          controller.verifiedAccountName!,
                                      accountNumber: _accountController.text,
                                      amount: double.parse(
                                        _amountController.text,
                                      ),
                                      narration: _narrationController.text,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: const Text("Continue"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
