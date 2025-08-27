import 'package:ansvel/homeandregistratiodesign/models/ad_slide.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class HomeController extends ChangeNotifier {
  List<AdSlide> _adSlides = [];
  List<AdSlide> get adSlides => _adSlides;

  bool _isLoadingAds = true;
  bool get isLoadingAds => _isLoadingAds;

  // --- NEW: A hardcoded list of 10 sample ads for offline/fallback use ---
  final List<AdSlide> _sampleSlides = [
    AdSlide(id: '1', imageUrl: 'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?q=80&w=2070&auto=format&fit=crop', title: 'Seamless Payments', subtitle: 'Send money to anyone, anywhere, instantly.', buttonText: 'Learn More', actionType: AdActionType.WebLink, actionTarget: 'https://flutter.dev'),
    AdSlide(id: '2', imageUrl: 'https://images.unsplash.com/photo-1593342371757-56e45b533a23?q=80&w=2070&auto=format&fit=crop', title: 'Your Food Delivered', subtitle: 'Order from your favorite local restaurants.', buttonText: 'Order Now', actionType: AdActionType.InAppPage, actionTarget: 'food_page'),
    AdSlide(id: '3', imageUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=2069&auto=format&fit=crop', title: 'Go Anywhere', subtitle: 'Book a ride to your destination in minutes.', buttonText: 'Book Ride', actionType: AdActionType.InAppPage, actionTarget: 'ride_page'),
    AdSlide(id: '4', imageUrl: 'https://images.unsplash.com/photo-1516321497487-e288fb19713f?q=80&w=2070&auto=format&fit=crop', title: 'Work Better, Together', subtitle: 'Unlock tools for your business and team.', buttonText: 'Explore', actionType: AdActionType.InAppPage, actionTarget: 'business_tools'),
    AdSlide(id: '5', imageUrl: 'https://images.unsplash.com/photo-1606103920215-fac219c41634?q=80&w=2070&auto=format&fit=crop', title: 'Pay Bills Easily', subtitle: 'Settle your electricity, cable, and more.', buttonText: 'Pay Now', actionType: AdActionType.InAppPage, actionTarget: 'bills_page'),
    AdSlide(id: '6', imageUrl: 'https://images.unsplash.com/photo-1554224155-1696413565d3?q=80&w=2070&auto=format&fit=crop', title: 'Grow Your Savings', subtitle: 'Explore investment and savings options.', buttonText: 'Get Started', actionType: AdActionType.WebLink, actionTarget: 'https://flutter.dev'),
    AdSlide(id: '7', imageUrl: 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?q=80&w=2070&auto=format&fit=crop', title: 'Your Security is Our Priority', subtitle: 'Learn about our advanced fraud protection.', buttonText: 'Learn More', actionType: AdActionType.InAppPage, actionTarget: 'security_page'),
    AdSlide(id: '8', imageUrl: 'https://images.unsplash.com/photo-1579621970795-87f54f597987?q=80&w=2070&auto=format&fit=crop', title: 'Refer & Earn', subtitle: 'Invite your friends to Ansvel and get rewarded.', buttonText: 'Invite Friends', actionType: AdActionType.InAppPage, actionTarget: 'referral_page'),
    AdSlide(id: '9', imageUrl: 'https://images.unsplash.com/photo-1620714223084-86c9df242d5d?q=80&w=1972&auto=format&fit=crop', title: 'Shop & Pay Later', subtitle: 'Flexible payment options for your favorite brands.', buttonText: 'Shop Now', actionType: AdActionType.WebLink, actionTarget: 'https://flutter.dev'),
    AdSlide(id: '10', imageUrl: 'https://images.unsplash.com/photo-1518458028785-8fbcd101ebb9?q=80&w=2070&auto=format&fit=crop', title: '24/7 Customer Support', subtitle: 'We are always here to help you.', buttonText: 'Contact Us', actionType: AdActionType.InAppPage, actionTarget: 'support_page'),
  ];
  
  HomeController() {
    fetchAds();
  }

  Future<void> fetchAds() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('advertisements').get();
      if (snapshot.docs.isNotEmpty) {
        // If ads are found in Firebase, use them
        _adSlides = snapshot.docs.map((doc) => AdSlide.fromFirestore(doc)).toList();
      } else {
        // --- UPDATED: Fallback to local samples if no ads are in Firestore ---
        _adSlides = _sampleSlides; 
      }
    } catch (e) {
      print("Error fetching ads: $e");
      // --- UPDATED: Fallback to local samples if there is an error ---
      _adSlides = _sampleSlides;
    }
    
    _isLoadingAds = false;
    notifyListeners();
  }
}