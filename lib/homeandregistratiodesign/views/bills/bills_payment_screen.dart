// import 'package:ansvel/services/bills_payment_api_service.dart';
// import 'package:ansvel/services/wallet_api_service.dart';
// import 'package:ansvel/widgets/pin_entry_dialog.dart';
import 'package:ansvel/homeandregistratiodesign/services/bills_payment_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/pin_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class BillsPaymentScreen extends StatefulWidget {
  const BillsPaymentScreen({Key? key}) : super(key: key);

  @override
  State<BillsPaymentScreen> createState() => _BillsPaymentScreenState();
}

class _BillsPaymentScreenState extends State<BillsPaymentScreen> {
  final BillsPaymentApiService _billsApiService = BillsPaymentApiService();
  final WalletApiService _walletApiService = WalletApiService();
  
  List<dynamic> _categories = [];
  List<dynamic> _billers = [];
  List<dynamic> _packages = [];
  bool _isLoadingCategories = true;
  bool _isLoadingBillers = false;
  bool _isLoadingPackages = false;
  bool _isPaying = false;

  String? _selectedCategorySlug;
  String? _selectedBillerSlug;
  String? _selectedPackageSlug;
  final _customerIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _billsApiService.getBillerCategories();
      if (mounted) setState(() => _categories = categories);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoadingCategories = false);
    }
  }

  Future<void> _loadBillers(String categorySlug) async {
    setState(() { _isLoadingBillers = true; _billers = []; _selectedBillerSlug = null; _packages = []; _selectedPackageSlug = null; });
    try {
      final billers = await _billsApiService.getBillersByCategory(categorySlug);
      if (mounted) setState(() => _billers = billers);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoadingBillers = false);
    }
  }

  Future<void> _loadPackages(String billerSlug) async {
    setState(() { _isLoadingPackages = true; _packages = []; _selectedPackageSlug = null; });
    try {
      final packages = await _billsApiService.getPackagesByBiller(billerSlug);
      if (mounted) setState(() => _packages = packages);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoadingPackages = false);
    }
  }
  
  void _onPay() {
    showDialog(
      context: context,
      builder: (context) => PinEntryDialog(
        onPinVerified: (pin) {
          Navigator.pop(context); // Close dialog
          _processPayment(pin);
        },
      ),
    );
  }

  Future<void> _processPayment(String pin) async {
    setState(() { _isPaying = true; });

    final double amount = double.tryParse(_amountController.text) ?? 0;
    const double fee = 5.0;
    final double totalWithFee = amount + fee;
    final double vat = totalWithFee * 0.075;
    final double finalAmount = totalWithFee + vat;
    final String paymentReference = uuid.v4();

    try {
      // Step 1: Debit the user's wallet
      await _walletApiService.debitWallet(
        amount: finalAmount,
        reference: paymentReference,
        customerId: "USER_PROVIDUS_CUSTOMER_ID", // This should be fetched from the user's profile
      );

      // Step 2: If debit is successful, vend the bill payment
      await _billsApiService.vendBillPayment(
        paymentReference: paymentReference,
        customerId: _customerIdController.text,
        packageSlug: _selectedPackageSlug!,
        amount: amount,
        phoneNumber: _phoneController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bill payment successful!"), backgroundColor: Colors.green));
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() { _isPaying = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bills Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isLoadingCategories) const Center(child: CircularProgressIndicator()),
            if (!_isLoadingCategories)
              DropdownButtonFormField<String>(
                value: _selectedCategorySlug,
                hint: const Text("Select Category"),
                isExpanded: true,
                items: _categories.map((cat) => DropdownMenuItem<String>(
                  value: cat['slug']?.toString(),
                  child: Text(cat['name']?.toString() ?? ''),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategorySlug = value);
                    _loadBillers(value);
                  }
                },
              ),
            if (_isLoadingBillers) const Padding(padding: EdgeInsets.all(8.0), child: Center(child: CircularProgressIndicator())),
            
            if (_billers.isNotEmpty) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedBillerSlug,
                hint: const Text("Select Biller"),
                isExpanded: true,
                items: _billers.map<DropdownMenuItem<String>>((biller) => DropdownMenuItem<String>(
                  value: biller['slug']?.toString(),
                  child: Text(biller['name']?.toString() ?? ''),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedBillerSlug = value);
                    _loadPackages(value);
                  }
                },
              ),
            ],
            if (_isLoadingPackages) const Padding(padding: EdgeInsets.all(8.0), child: Center(child: CircularProgressIndicator())),

            if (_packages.isNotEmpty) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPackageSlug,
                hint: const Text("Select Package"),
                isExpanded: true,
                items: _packages.map<DropdownMenuItem<String>>((pkg) => DropdownMenuItem<String>(
                  value: pkg['slug']?.toString(),
                  child: Text("${pkg['name']} - ₦${pkg['amount']}"),
                )).toList(),
                onChanged: (value) {
                  // When a fixed-amount package is selected, update the amount field
                  final selectedPackage = _packages.firstWhere((p) => p['slug'] == value, orElse: () => null);
                  if (selectedPackage != null && selectedPackage['amount'] > 0) {
                    _amountController.text = selectedPackage['amount'].toString();
                  }
                  setState(() => _selectedPackageSlug = value);
                },
              ),
            ],

            if (_selectedPackageSlug != null) ...[
              const SizedBox(height: 24),
              TextFormField(controller: _customerIdController, decoration: const InputDecoration(labelText: 'Customer ID (e.g., Meter No.)')),
              const SizedBox(height: 16),
              TextFormField(controller: _amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₦)')),
              const SizedBox(height: 16),
              TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number')),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isPaying ? null : _onPay,
                  child: _isPaying ? const CircularProgressIndicator(color: Colors.white) : const Text("PAY"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}