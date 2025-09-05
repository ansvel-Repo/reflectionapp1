import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/transaction_history_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/other_bank_transfer/transfer_to_bank_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/transfer_to_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletDashboardScreen extends StatefulWidget {
  final Wallet wallet;
  const WalletDashboardScreen({super.key, required this.wallet});

  @override
  State<WalletDashboardScreen> createState() => _WalletDashboardScreenState();
}

class _WalletDashboardScreenState extends State<WalletDashboardScreen> {
  final WalletApiService _walletApiService = WalletApiService();
  Future<Map<String, dynamic>>? _balanceFuture;

  @override
  void initState() {
    super.initState();
    _balanceFuture = _walletApiService.getWalletBalance(
      customerId: widget.wallet.customerId,
      provider: widget.wallet.provider,
    );
  }

  void _refreshBalance() {
    setState(() {
      _balanceFuture = _walletApiService.getWalletBalance(
        customerId: widget.wallet.customerId,
        provider: widget.wallet.provider,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.wallet.bankName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshBalance,
            tooltip: "Refresh Balance",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.shade400,
                    Colors.purple.shade500,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Available Balance",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _balanceFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return Text(
                          "₦ 0.00",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      // Correctly access the nested balance value from the API response.
                      final balance =
                          snapshot.data?['wallet']?['availableBalance'] ?? 0.0;
                      return Text(
                        "₦ ${balance.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.wallet.accountName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.wallet.accountNumber,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: FontAwesomeIcons.paperPlane,
                  label: "Send",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransferToWalletScreen(),
                      ),
                    );
                  },
                ),
                _ActionButton(
                  icon: FontAwesomeIcons.buildingColumns,
                  label: "To Bank",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TransferToBankScreen(sourceWallet: widget.wallet),
                      ),
                    );
                  },
                ),
                _ActionButton(
                  icon: FontAwesomeIcons.wallet,
                  label: "Add Funds",
                  onTap: () {},
                ),
                _ActionButton(
                  icon: FontAwesomeIcons.receipt,
                  label: "History",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionHistoryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            // In a real-world app, a list of recent transactions would be displayed here.
          ],
        ),
      ),
    );
  }
}

// Helper widget for the action buttons
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}