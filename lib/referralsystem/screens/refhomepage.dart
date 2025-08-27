import 'package:ansvel/homeandregistratiodesign/views/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:ansvel/pin/set_pin_page.dart';
import 'package:ansvel/referralsystem/screens/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';



import 'package:ansvel/referralsystem/utils/message.dart';

import 'package:share_plus/share_plus.dart';


class RefHomePage extends StatefulWidget {
  const RefHomePage({super.key});

  @override
  State<RefHomePage> createState() => _RefHomePageState();
}

class _RefHomePageState extends State<RefHomePage> {
  final CollectionReference profileRef =
      FirebaseFirestore.instance.collection("Users");

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _hasInternet = true;
  bool _isLoading = false;
  bool _hasPin = false;
  double _referralSum = 0;

  @override
  void initState() {
    super.initState();
    _checkInternetAndPin();
  }

  Future<void> _checkInternetAndPin() async {
    setState(() => _isLoading = true);
    
    // Check internet connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasInternet = false;
        _isLoading = false;
      });
      return;
    }
    
    // Check if user has PIN
    if (auth.currentUser != null) {
      final userDoc = await profileRef.doc(auth.currentUser!.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _hasPin = data.containsKey('pin') && data['pin'] != null;
          _referralSum = (data['referralCode'] ?? 0).toDouble();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _moveReferralToWallet() async {
    if (_referralSum <= 0) return;

    setState(() => _isLoading = true);
    
    try {
      final userDoc = profileRef.doc(auth.currentUser!.uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDoc);
        if (!snapshot.exists) return;

        final data = snapshot.data() as Map<String, dynamic>;
        final currentWallet = (data['walletAmount'] ?? 0).toDouble();
        final currentReferralEarnings = (data['refEarnings'] ?? 0).toDouble();

        transaction.update(userDoc, {
          'walletAmount': currentWallet + currentReferralEarnings,
          'refEarnings': 0,
        });
      });

      setState(() {
        _referralSum = 0;
        _isLoading = false;
      });
      showMessage(context, "Referral sum moved to wallet successfully!");
    } catch (e) {
      setState(() => _isLoading = false);
      showMessage(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Referral page",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => SplashScreen()),
                    (route) => false);
              });
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
            weight: 500,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavWithAnimatedIcons()),
            );
          },
        ),
      ),
      body: _hasInternet 
          ? _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<QuerySnapshot>(
                  future: _fetchReferrals(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No referral data found."));
                    }

                    final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                    final earnings = data["refEarnings"] ?? 0;
                    final referalsList = List<String>.from(data["referals"] ?? []);
                    final refCode = data["refCode"] ?? "N/A";
                    final refAmount = data["referralAmount"] ?? 0;

                    return RefreshIndicator(
                      onRefresh: () {
                        setState(() {});
                        return Future.delayed(const Duration(seconds: 2));
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                Card(
                                  child: ListTile(
                                    title: const Text("Earnings"),
                                    subtitle: Text("NGN $earnings"),
                                  ),
                                ),
                                const Divider(thickness: 3),
                                Card(
                                  child: ListTile(
                                    title: const Text("Referral Code"),
                                    subtitle: Text(refCode),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: refCode));
                                        showMessage(context, "Referral code copied");
                                      },
                                      icon: const Icon(Icons.copy),
                                    ),
                                  ),
                                ),
                                const Divider(thickness: 3),
                                Card(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Text(
                                          "Invite your friends and earn ₦$refAmount in your ride wallet when they register using your referral code. Each referral is verified using BVN to prevent duplicate accounts. Payouts are made at the end of every month. Earn ₦1,000 whenever yor referral spends multiples of NGN50,000 capped at ₦5,000 on the app. Win ₦10,000,000.00 if you refer the most people by March 30th, 2026",
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          String shareLink =
                                              "Hey! Use this app to share rides, run your business, and find vendors! Earn NGN $refAmount for every new signup with my referral code ($refCode)!";
                                          Share.share(shareLink);
                                        },
                                        child: const Text("Share link"),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(thickness: 3),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Referrals"),
                                      Text("${referalsList.length}"),
                                    ],
                                  ),
                                ),
                                if (referalsList.isEmpty) const Text("No referrals yet."),
                                ...List.generate(referalsList.length, (index) {
                                  final refData = referalsList[index];
                                  return Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      leading: CircleAvatar(child: Text("${index + 1}")),
                                      title: Text(refData),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.signal_wifi_off, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text(
                    "No Internet Connection",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please check your connection and try again",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkInternetAndPin,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _hasInternet && !_isLoading
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_referralSum > 0 && _hasPin)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _moveReferralToWallet,
                        child: const Text(
                          "Move Referral Sum to Wallet",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _hasPin
                        ? FloatingActionButton.extended(
                            onPressed: () {
                              Get.offAll(const BottomNavWithAnimatedIcons());
                            },
                            backgroundColor: const Color.fromARGB(255, 143, 58, 213),
                            foregroundColor: const Color(0xff1B1D28),
                            label: const Text(
                              "Home Screen",
                              style: TextStyle(fontSize: 22),
                            ),
                          )
                        : FloatingActionButton.extended(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SetPinPage(),
                                ),
                              );
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            label: const Text(
                              "Set PIN",
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Future<QuerySnapshot> _fetchReferrals() async {
    if (auth.currentUser == null) {
      throw "User not logged in.";
    }

    final snapshot = await profileRef
        .where("refCode", isEqualTo: auth.currentUser?.uid)
        .get();

    return snapshot;
  }
}