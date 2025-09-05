// lib/screens/credit_wallet_screen.dart
import 'dart:convert';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/tokenized_card.dart';
import 'package:ansvel/homeandregistratiodesign/services/api_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/local_notification_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/payment_api_service.dart' show PaystackKeyManager;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:paystack_flutter_sdk/paystack_flutter_sdk.dart';
// import '../services/paystack_key_manager.dart';
// import '../services/api_service.dart';
// import '../models/tokenized_card.dart';
import '../widgets/card_list_tile.dart';
// import '../controllers/auth_controller.dart'; // your existing auth provider
// import '../services/local_notification_service.dart';
// import 'package:http/http.dart' as http;

const Uuid uuid = Uuid();

class CreditWalletScreen extends StatefulWidget {
  const CreditWalletScreen({Key? key}) : super(key: key);

  @override
  State<CreditWalletScreen> createState() => _CreditWalletScreenState();
}

class _CreditWalletScreenState extends State<CreditWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isLoading = false;
  List<TokenizedCard> _savedCards = [];
  String? _selectedAuthCode;
  int? _paystackFee;
  int? _serviceFee;
  int? _totalCharge; // NGN
  final ApiService _api = ApiService.instance;
  final _notify = LocalNotificationService();

  @override
  void initState() {
    super.initState();
    PaystackKeyManager.instance.init();
    _amountController.addListener(_onAmountChange);
    _loadSavedCards();
  }

  Future<void> _loadSavedCards() async {
    try {
      // adapt userId retrieval to your auth
      final auth = Provider.of<AuthController>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'anonymous';
      final cards = await _api.getSavedCards(userId: userId);
      setState(() => _savedCards = cards);
    } catch (e) {
      // ignore silently — saved cards are optional
    }
  }

  void _onAmountChange() {
    final val = double.tryParse(_amountController.text) ?? 0;
    if (val > 0) {
      _fetchFeePreview(val);
    } else {
      setState(() {
        _paystackFee = null;
        _serviceFee = null;
        _totalCharge = null;
      });
    }
  }

  Future<void> _fetchFeePreview(double amount) async {
    try {
      final res = await _api.fetchFeePreview(amount);
      if (res != null && res['success'] == true) {
        final data = res['data'];
        setState(() {
          _paystackFee = data['paystackFee'] as int?;
          _serviceFee = data['serviceFee'] as int?;
          _totalCharge = data['totalCharge'] as int?;
        });
      }
    } catch (e) {
      // ignore preview failures
    }
  }

  Future<void> _startPayment() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<AuthController>(context, listen: false);
    if (auth.currentUser == null) {
      _notify.showErrorPopup(
        context,
        'Not signed in',
        'Please sign in to continue.',
      );
      return;
    }
    final email = auth.currentUser?.email ?? '';
    final userId = auth.currentUser?.uid ?? '';

    final double amountNgn = double.tryParse(_amountController.text) ?? 0;
    if (amountNgn <= 0) return;
    final String reference = 'ansvel_credit_${uuid.v4()}';

    setState(() => _isLoading = true);

    try {
      // Initialize SDK with public key
      final publicKey = await PaystackKeyManager.instance.getPublicKey();
      if (publicKey == null)
        throw Exception('Payment provider key unavailable');
      final initialized = await Paystack().initialize(publicKey, true);
      if (!initialized) throw Exception('Failed to initialize Paystack SDK');

      // If a saved card is selected -> charge via backend using the authCode
      if (_selectedAuthCode != null && _selectedAuthCode!.isNotEmpty) {
        // we need amount in kobo: backend expects amountKobo when charging saved card
        // totalCharge is returned in NGN by server's /paystack/fee or /init. If missing, call preview.
        int amountKobo;
        if (_totalCharge != null) {
          amountKobo = _totalCharge! * 100;
        } else {
          // fallback: ask server to calculate total again
          final feeResp = await _api.fetchFeePreview(amountNgn);
          final tc = (feeResp != null && feeResp['success'] == true)
              ? feeResp['data']['totalCharge'] as int
              : (amountNgn).round();
          amountKobo = tc * 100;
        }

        final chargeResp = await _api.chargeSavedCard(
          userId: userId,
          authCode: _selectedAuthCode!,
          amountKobo: amountKobo,
          email: email,
          reference: reference,
        );

        if (chargeResp != null && chargeResp['status'] == true) {
          // server returned Paystack response object; verify on server to be safe
          final verify = await _api.verifyTransaction(reference);
          if (verify != null) {
            _notify.showSuccessPopup(
              context,
              'Success',
              'Your wallet has been credited.',
            );
            // optionally refresh UI: wallet balances etc.
          } else {
            _notify.showErrorPopup(
              context,
              'Verification failed',
              'Please contact support.',
            );
          }
        } else {
          _notify.showErrorPopup(
            context,
            'Charge failed',
            chargeResp?['message'] ?? 'Unable to charge saved card',
          );
        }
      } else {
        // New card flow: initialize transaction on server (server computes fees & returns access_code)
        final initResp = await _api.initTransaction(
          email: email,
          amountNgn: amountNgn,
          reference: reference,
        );
        if (initResp == null || initResp['data'] == null)
          throw Exception('Payment initialization failed');
        final paystackData = initResp['data'] as Map<String, dynamic>;
        final accessCode = paystackData['access_code'] as String?;
        final feesFromServer = initResp['fees'] as Map<String, dynamic>?;
        if (feesFromServer != null) {
          setState(() {
            _paystackFee = feesFromServer['paystackFee'] as int?;
            _serviceFee = feesFromServer['serviceFee'] as int?;
            _totalCharge = feesFromServer['totalCharge'] as int?;
          });
        }

        if (accessCode == null)
          throw Exception('No access_code returned from server');

        // Launch Paystack checkout using access_code
        final checkoutResult = await Paystack().launch(accessCode);

        // checkoutResult shape depends on paystack_flutter_sdk; adapt as needed
        // We expect Paystack SDK to return an object with .status and .reference (and maybe .message)
        if (checkoutResult.status == 'success' ||
            checkoutResult.status == 'completed' ||
            checkoutResult.status == true) {
          // Verify on server; server verification response should include authorization object (auth_code + card info)
          final verifyResp = await _api.verifyTransaction(
            checkoutResult.reference ?? reference,
          );
          if (verifyResp != null) {
            // verifyResp['data'] should contain Paystack verify payload and authorization object
            final data =
                verifyResp['data'] as Map<String, dynamic>? ?? verifyResp;
            final auth =
                data['data']?['authorization'] ??
                data['authorization'] ??
                data['data'] ??
                null;
            // Try to extract authorization_code & card info
            String? authorizationCode;
            Map<String, dynamic>? cardInfo;
            try {
              // common Paystack structure: response.data.data.authorization
              final inner = (verifyResp['data'] is Map)
                  ? verifyResp['data']['data'] ?? verifyResp['data']
                  : verifyResp['data'];
              if (inner != null &&
                  inner is Map &&
                  inner['authorization'] != null) {
                authorizationCode = inner['authorization']['authorization_code']
                    ?.toString();
                final card =
                    inner['authorization']['card'] ??
                    inner['card'] ??
                    inner['authorization'];
                if (card != null && card is Map) {
                  cardInfo = {
                    'brand': card['brand'] ?? card['card_brand'] ?? '',
                    'last4': card['last4'] ?? '',
                    'exp_month': card['exp_month'] ?? card['exp_month'],
                    'exp_year': card['exp_year'] ?? card['exp_year'],
                    'bank': card['bank'] ?? '',
                  };
                }
              }
            } catch (_) {}

            // Ask user whether to save card
            if (authorizationCode != null && mounted) {
              final shouldSave = await _askSaveCard();
              if (shouldSave == true && cardInfo != null) {
                final userId =
                    Provider.of<AuthController>(
                      context,
                      listen: false,
                    ).currentUser?.uid ??
                    '';
                final saved = await _api.saveCard(
                  userId: userId,
                  authCode: authorizationCode,
                  cardInfo: cardInfo,
                );
                if (saved) {
                  _notify.showSuccessPopup(
                    context,
                    'Saved',
                    'Card saved for future payments.',
                  );
                  await _loadSavedCards(); // refresh list
                } else {
                  _notify.showErrorPopup(
                    context,
                    'Save failed',
                    'Could not save card. Try again later.',
                  );
                }
              }
            }

            _notify.showSuccessPopup(
              context,
              'Payment successful',
              'Your wallet has been credited.',
            );
          } else {
            _notify.showErrorPopup(
              context,
              'Verification failed',
              'Could not verify payment. Contact support.',
            );
          }
        } else {
          // checkout cancelled or failed
          _notify.showErrorPopup(
            context,
            'Payment failed',
            checkoutResult.message ?? 'Payment cancelled or failed.',
          );
        }
      }
    } catch (e) {
      _notify.showErrorPopup(context, 'Error', e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool?> _askSaveCard() async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Save card for future?'),
          content: const Text(
            'Would you like to save this card so you can pay faster next time?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Widget _buildSavedCardsList() {
    if (_savedCards.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saved cards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ..._savedCards.map((c) {
          final selected = c.authCode == _selectedAuthCode;
          return CardListTile(
            card: c,
            selected: selected,
            onTap: () => setState(() => _selectedAuthCode = c.authCode),
          );
        }).toList(),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => setState(() => _selectedAuthCode = null),
          icon: const Icon(Icons.add),
          label: const Text('Add new card'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallets =
        Provider.of<AuthController>(
          context,
        ).currentUser?.wallets.values.toList() ??
        [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Credit Your Wallet',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField(
                value: null,
                decoration: InputDecoration(
                  labelText: 'Choose Wallet',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: wallets.map<DropdownMenuItem>((wallet) {
                  final display =
                      "${wallet.bankName} - (...${wallet.accountNumber.substring(wallet.accountNumber.length - 4)})";
                  return DropdownMenuItem(value: wallet, child: Text(display));
                }).toList(),
                onChanged: (val) {},
                hint: const Text('Select wallet to credit'),
                validator: (v) => v == null ? 'Please select a wallet' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount (₦)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0
                    ? 'Please enter a valid amount'
                    : null,
              ),

              const SizedBox(height: 12),

              if (_paystackFee != null &&
                  _serviceFee != null &&
                  _totalCharge != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paystack fee: ₦${_paystackFee}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Service fee: ₦${_serviceFee}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Total to be charged: ₦${_totalCharge}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              _buildSavedCardsList(),

              const Spacer(),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startPayment,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Proceed to Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
