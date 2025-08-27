// lib/widgets/panic_button.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class PanicButton extends StatefulWidget {
  const PanicButton({super.key});
  @override
  State<PanicButton> createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton> {
  bool _isPanicking = false;
  LocationData? _currentLocation;
  final Location _locationService = Location();
  Timer? _locationTimer;
  final User? _user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(_user!.uid).get();
        if (userDoc.exists && mounted) {
          setState(() {
            _userData = userDoc.data() as Map<String, dynamic>;
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _handlePanicButtonPress,
      backgroundColor: _isPanicking ? Colors.red[900] : Colors.red,
      tooltip: 'Emergency Panic Button',
      child: Icon(
        _isPanicking ? Icons.location_on : Icons.warning_amber_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Future<void> _handlePanicButtonPress() async {
    if (_isPanicking) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency Mode Active. Help is on the way!')));
      return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚨 EMERGENCY', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 60),
              SizedBox(height: 20),
              Text('Pressing "EMERGENCY" will immediately alert authorities and share your location.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text('WARNING: False alarms will result in a ₦50,000 fine and account suspension.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('EMERGENCY', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isPanicking = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency Alert Activated!'), backgroundColor: Colors.red));
      
      // In a real app, you would trigger backend services here for calls and alerts.
      // For example: await ApiService.triggerEmergencyProtocol(_userData);
      _startLocationSharing();
    }
  }

  Future<void> _startLocationSharing() async {
    // Logic for handling location permissions and sharing
    // ...
  }
}