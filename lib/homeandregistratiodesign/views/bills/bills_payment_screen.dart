import 'package:ansvel/homeandregistratiodesign/widgets/buttonloadingwidget.dart';
import 'package:flutter/material.dart';
import 'package:ansvel/homeandregistratiodesign/services/bills_payment_api_service.dart';
// import 'package:ansvel/homeandregistratiodesign/views/widgets/buttonloadingwidget.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/result_dialog.dart';

class BillsPaymentScreen extends StatefulWidget {
  const BillsPaymentScreen({super.key});

  @override
  State<BillsPaymentScreen> createState() => _BillsPaymentScreenState();
}

class _BillsPaymentScreenState extends State<BillsPaymentScreen> {
  final _billsService = BillsPaymentApiService();
  final _formKey = GlobalKey<FormState>();

  String? _selectedCategorySlug;
  String? _selectedBillerSlug;
  String? _selectedPackageSlug;

  List<dynamic> _billerCategories = [];
  List<dynamic> _billers = [];
  List<dynamic> _packages = [];

  bool _isLoading = false;
  bool _isLookingUpCustomer = false;
  Map<String, dynamic>? _customerDetails;

  final _customerIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBillerCategories();
  }

  @override
  void dispose() {
    _customerIdController.dispose();
    _amountController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _fetchBillerCategories() async {
    setState(() => _isLoading = true);
    try {
      final categories = await _billsService.getBillerCategories();
      setState(() => _billerCategories = categories);
    } catch (e) {
      _showResultDialog(
        'Error',
        'Failed to fetch biller categories: ${e.toString()}',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchBillers() async {
    if (_selectedCategorySlug == null) return;
    setState(() {
      _isLoading = true;
      _billers = [];
      _selectedBillerSlug = null;
      _packages = [];
      _selectedPackageSlug = null;
    });

    try {
      final billers = await _billsService.getBillersByCategory(
        _selectedCategorySlug!,
      );
      setState(() => _billers = billers);
    } catch (e) {
      _showResultDialog('Error', 'Failed to fetch billers: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchPackages() async {
    if (_selectedBillerSlug == null) return;
    setState(() {
      _isLoading = true;
      _packages = [];
      _selectedPackageSlug = null;
    });

    try {
      final packages = await _billsService.getPackagesByBiller(
        _selectedBillerSlug!,
      );
      setState(() => _packages = packages);
    } catch (e) {
      _showResultDialog('Error', 'Failed to fetch packages: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _lookupCustomer() async {
    if (_selectedBillerSlug == null ||
        _customerIdController.text.isEmpty ||
        _selectedPackageSlug == null) {
      return;
    }

    setState(() => _isLookingUpCustomer = true);

    try {
      final customerData = await _billsService.customerLookup(
        customerId: _customerIdController.text,
        billerSlug: _selectedBillerSlug!,
        productName: _selectedPackageSlug!,
      );
      setState(() => _customerDetails = customerData);
    } catch (e) {
      _showResultDialog(
        'Lookup Failed',
        'Could not find customer: ${e.toString()}',
      );
    } finally {
      setState(() => _isLookingUpCustomer = false);
    }
  }

  Future<void> _vendPayment() async {
    if (!_formKey.currentState!.validate() || _customerDetails == null) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _billsService.vendBillPayment(
        paymentReference: uuid.v4(),
        customerId: _customerIdController.text,
        packageSlug: _selectedPackageSlug!,
        amount: double.parse(_amountController.text),
        phoneNumber: _phoneNumberController.text,
        customerName: _customerDetails!['customerName'],
        email: _customerDetails!['emailAddress'],
      );
      _showResultDialog(
        'Success',
        'Payment successful. Token: ${result['responseData']['tokenData']['value']}',
      );
    } catch (e) {
      _showResultDialog('Payment Failed', e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showResultDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResultDialog(
          title: title,
          message: message,
          isSuccess: title.toLowerCase().contains('success'),
          onDone: () => Navigator.of(context).pop(),
          // onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bills Payment')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBillerCategoryDropdown(),
                    const SizedBox(height: 16),
                    _buildBillerDropdown(),
                    const SizedBox(height: 16),
                    _buildPackageDropdown(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _customerIdController,
                      decoration: InputDecoration(
                        labelText: 'Customer ID (e.g., Meter Number)',
                        border: const OutlineInputBorder(),
                        suffixIcon: _isLookingUpCustomer
                            ? const CircularProgressIndicator()
                            : IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: _lookupCustomer,
                              ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a customer ID' : null,
                    ),
                    if (_customerDetails != null) ...[
                      const SizedBox(height: 16),
                      _buildCustomerInfoCard(),
                    ],
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (optional for fixed packages)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (_selectedPackageSlug == null) {
                          return 'Please select a package first';
                        }
                        return null; // The backend handles amount validation for specific packages.
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a phone number' : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: (_isLoading || _customerDetails == null)
                          ? null
                          : _vendPayment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const ButtonLoadingWidget()
                          : const Text('Pay Bill'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBillerCategoryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Biller Category',
        border: OutlineInputBorder(),
      ),
      value: _selectedCategorySlug,
      items: _billerCategories.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem<String>(
          value: category['slug'],
          child: Text(category['name']),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategorySlug = newValue;
          _selectedBillerSlug = null;
          _billers = [];
          _packages = [];
          _customerDetails = null;
        });
        _fetchBillers();
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildBillerDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Biller',
        border: OutlineInputBorder(),
      ),
      value: _selectedBillerSlug,
      items: _billers.map<DropdownMenuItem<String>>((biller) {
        return DropdownMenuItem<String>(
          value: biller['slug'],
          child: Text(biller['name']),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedBillerSlug = newValue;
          _selectedPackageSlug = null;
          _packages = [];
          _customerDetails = null;
        });
        _fetchPackages();
      },
      validator: (value) => value == null ? 'Please select a biller' : null,
    );
  }

  Widget _buildPackageDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Package',
        border: OutlineInputBorder(),
      ),
      value: _selectedPackageSlug,
      items: _packages.map<DropdownMenuItem<String>>((package) {
        return DropdownMenuItem<String>(
          value: package['slug'],
          child: Text(package['name']),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPackageSlug = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a package' : null,
    );
  }

  Widget _buildCustomerInfoCard() {
    if (_customerDetails == null) {
      return const SizedBox.shrink();
    }
    final customer = _customerDetails!['customer'] as Map<String, dynamic>;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow('Name', customer['customerName']),
            _buildInfoRow('Account Number', customer['accountNumber']),
            _buildInfoRow('Address', customer['address']),
            if (_customerDetails!['arrearsBalance'] != null &&
                _customerDetails!['arrearsBalance'] > 0)
              _buildInfoRow(
                'Outstanding Balance',
                '₦${_customerDetails!['arrearsBalance']}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
