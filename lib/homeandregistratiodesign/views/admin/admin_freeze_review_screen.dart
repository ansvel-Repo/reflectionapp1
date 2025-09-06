import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/result_dialog.dart';

class AdminFreezeReviewScreen extends StatefulWidget {
  const AdminFreezeReviewScreen({super.key});

  @override
  State<AdminFreezeReviewScreen> createState() => _AdminFreezeReviewScreenState();
}

class _AdminFreezeReviewScreenState extends State<AdminFreezeReviewScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WalletApiService _apiService = WalletApiService();
  
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final currentUser = authController.currentUser;
    final userRole = currentUser?.role.toString().toLowerCase();

    if (currentUser == null || (userRole != 'admin' && userRole != 'subadmin')) {
      return Scaffold(
        appBar: AppBar(title: const Text("Access Denied")),
        body: const Center(
          child: Text(
            "You do not have permission to view this page.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Freeze Order Reviews",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('FreezeRequests').where('status', isEqualTo: 'pending_review').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No pending freeze requests to review."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text("Wallet ID: ${data['customerId']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "Reason: ${data['reason']}\n"
                    "Requestor: ${data['requestorUid']}\n"
                    "Court Order: ${data['courtOrderUrl']}\n"
                    "Requested on: ${data['timestamp'].toDate()}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => _approveFreeze(doc.id, data['customerId'], data['provider']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _declineFreeze(doc.id, data['customerId'], data['provider']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  Future<void> _approveFreeze(String docId, String customerId, String provider) async {
    try {
      await _apiService.approveFreeze(
        docId: docId,
        customerId: customerId,
        provider: provider,
        action: 'approve',
      );
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => ResultDialog(
            isSuccess: true,
            title: "Freeze Approved",
            message: "The freeze request has been approved and the wallet is now unfrozen.", onDone: () { Navigator.of(context).pop(); },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => ResultDialog(
            isSuccess: false,
            title: "Approval Failed",
            message: e.toString().replaceFirst("Exception: ", ""), onDone: () { Navigator.of(context).pop(); },
          ),
        );
      }
    }
  }

  Future<void> _declineFreeze(String docId, String customerId, String provider) async {
    try {
      await _apiService.approveFreeze(
        docId: docId,
        customerId: customerId,
        provider: provider,
        action: 'decline',
      );
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => ResultDialog(
            isSuccess: true,
            title: "Freeze Declined",
            message: "The freeze request has been declined.", onDone: () { Navigator.of(context).pop(); },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => ResultDialog(
            isSuccess: false,
            title: "Decline Failed",
            message: e.toString().replaceFirst("Exception: ", ""), onDone: () { Navigator.of(context).pop(); },
          ),
        );
      }
    }
  }
}