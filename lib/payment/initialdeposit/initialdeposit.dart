import 'package:ansvel/loginapp/src/features/authentication/screens/completesignup/completesignup.dart';
import 'package:ansvel/payment/paystackpayment.dart';
import 'package:ansvel/payment/transaction_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialDepositScreen extends StatefulWidget {
  const InitialDepositScreen({super.key});

  @override
  State<InitialDepositScreen> createState() => _InitialDepositScreenState();
}

class _InitialDepositScreenState extends State<InitialDepositScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TransactionService _transactionService = TransactionService();
  double? _initialDepositAmount;
  bool _isLoading = true;
  bool _isProcessingPayment = false;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      // Fetch initial deposit amount from the correct path
      final depositSnapshot =
          await _firestore.collection('variables').doc('initialDeposit').get();

      // Fetch user email from Users collection with fallback
      final user = _auth.currentUser;
      if (user != null) {
        final userSnapshot =
            await _firestore.collection('Users').doc(user.uid).get();
        if (userSnapshot.exists) {
          _userEmail =
              userSnapshot.data()?['email'] ?? '${user.uid}@ansvel.com';
        } else {
          _userEmail = '${user.uid}@ansvel.com';
        }
      }

      if (depositSnapshot.exists && depositSnapshot.data()?['value'] != null) {
        setState(() {
          // Convert the value to double (handles both string and numeric values)
          final value = depositSnapshot.data()!['value'];
          _initialDepositAmount =
              value is String ? double.parse(value) : value.toDouble();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showError('Initial deposit amount not configured');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to fetch initial data: ${e.toString()}');
    }
  }

  Future<void> _processInitialDeposit() async {
    if (_initialDepositAmount == null || _userEmail == null) {
      _showError('Unable to process deposit. Please try again.');
      return;
    }

    setState(() => _isProcessingPayment = true);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Process payment using Paystack
      final paymentSuccess = await PaymentService.processPayment(
        context: context,
        email: _userEmail!,
        amount: _initialDepositAmount!.toInt(),
      );

      if (paymentSuccess) {
        final walletCredit = _initialDepositAmount! * 0.95;

        // Batch write for atomic updates
        final batch = _firestore.batch();

        // Update wallet
        final userRef = _firestore.collection('Users').doc(user.uid);
        batch.update(userRef, {
          'walletAmount': FieldValue.increment(walletCredit),
          'hasCompletedInitialDeposit': true,
        });

        // Record transaction using the service
        await _transactionService.recordTransactionWithBatch(
          narration: 'Initial Deposit',
          transactionType: 'Credit',
          amount: _initialDepositAmount!,
          recipient: 'Ansvel Wallet',
          batch: batch,
        );

        await batch.commit();

        // Show success animation
        await _showSuccessAnimation();

        // Navigate to verification screen
        Get.offAll(() => const VerificationPendingScreen());
      }
    } catch (e) {
      _showError('Failed to process deposit: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  Future<void> _showSuccessAnimation() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deposit Successful!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.of(context).pop();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple,
              Color(0xFF9575CD),
            ],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Initial Deposit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main Content
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // Illustration
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              child: Image.asset(
                                'assets/images/logos/ansvelblackremovebg.png',
                                height: 80,
                              ),
                            ),

                            // Deposit Card
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Required Initial Deposit',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    '₦${_initialDepositAmount?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(height: 20),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Wallet Credit:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '₦${(_initialDepositAmount != null ? (_initialDepositAmount! * 0.95).toStringAsFixed(2) : '0.00')}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Service Fee (5%):',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '₦${(_initialDepositAmount != null ? (_initialDepositAmount! * 0.05).toStringAsFixed(2) : '0.00')}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Benefits Section
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Why Deposit to Your Wallet?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  _buildBenefitItem(
                                    icon: Icons.security_rounded,
                                    text:
                                        'Secure payments protected by Ansvel\'s insurance',
                                  ),
                                  _buildBenefitItem(
                                    icon: Icons.bolt_rounded,
                                    text:
                                        'Instant payments for faster ride bookings',
                                  ),
                                  _buildBenefitItem(
                                    icon: Icons.discount_rounded,
                                    text:
                                        'Exclusive discounts for wallet users',
                                  ),
                                  _buildBenefitItem(
                                    icon: Icons.history_rounded,
                                    text:
                                        'Complete transaction history tracking',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Deposit Button
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 66,
                        child: ElevatedButton(
                          onPressed: _isProcessingPayment
                              ? null
                              : _processInitialDeposit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            shadowColor: Colors.deepPurple.withOpacity(0.3),
                          ),
                          child: _isProcessingPayment
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.deepPurple,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'PROCEED TO DEPOSIT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildBenefitItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
