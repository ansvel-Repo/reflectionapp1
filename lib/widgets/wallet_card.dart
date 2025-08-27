
import 'package:ansvel/homeandregistratiodesign/controllers/wallet_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WalletCard extends StatefulWidget {
  final Wallet? wallet;
  final bool isOffline;
  final bool isDummy;

  const WalletCard({super.key, required this.wallet, this.isOffline = false}) : isDummy = false;
  const WalletCard.dummy({super.key, this.isOffline = true}) : wallet = null, isDummy = true;

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  bool _showBalance = false;

  void _toggleBalanceVisibility() {
    if (widget.isDummy || widget.isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please connect to the internet to check your balance.")),
      );
      return;
    }
    
    setState(() {
      _showBalance = !_showBalance;
      if (_showBalance && widget.wallet!.availableBalance == null) {
        Provider.of<WalletController>(context, listen: false).fetchBalance(widget.wallet!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = widget.wallet != null ? Provider.of<WalletController>(context).wallets[widget.wallet!.id] : null;
    final isLoading = widget.wallet != null ? Provider.of<WalletController>(context).loadingStates[widget.wallet!.id] ?? false : false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              widget.isDummy ? Colors.grey.shade500 : Colors.deepPurpleAccent.shade400,
              widget.isDummy ? Colors.grey.shade700 : Colors.purple.shade500,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.isDummy ? "Ansvel Wallet" : widget.wallet!.bankName, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                IconButton(
                  icon: Icon(_showBalance ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                  onPressed: _toggleBalanceVisibility,
                ),
              ],
            ),
            if (widget.isOffline && !widget.isDummy)
              const Text("Offline Mode", style: TextStyle(color: Colors.white54, fontSize: 12)),
            const Spacer(),
            Text("Available Balance", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            if (isLoading)
              const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(color: Colors.white)))
            else
              Text(
                _showBalance ? "₦ ${walletState?.availableBalance?.toStringAsFixed(2) ?? 'Tap to view'}" : "••••••••",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16),
            Text(widget.isDummy ? "Login to view your wallets" : widget.wallet!.accountNumber, style: GoogleFonts.poppins(color: Colors.white70, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }
}