import 'package:ansvel/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthWrapper()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: const [
              _OnboardingPage(
                image: 'assets/images/onboarding1.png',
                title: 'Welcome to Ansvel',
                subtitle:
                    'The all-in-one super app designed to simplify your life.',
                color: Color(0xFFF3E5F5),
              ),
              _OnboardingPage(
                image: 'assets/images/onboarding2.png',
                title: 'Secure & Instant Payments',
                subtitle:
                    'Send and receive money, pay bills, and manage your wallet with ease.',
                color: Color(0xFFE3F2FD),
              ),
              _OnboardingPage(
                image: 'assets/images/onboarding3.png',
                title: 'Services at Your Fingertips',
                subtitle:
                    'From ride-hailing to food delivery, everything you need is just a tap away.',
                color: Color(0xFFE8F5E9),
              ),
              _OnboardingPage(
                image: 'assets/images/onboarding4.png',
                title: 'Stay Connected',
                subtitle:
                    'Chat with friends, family, and businesses all in one place.',
                color: Color(0xFFFFF3E0),
              ),
              _OnboardingPage(
                image: 'assets/images/onboarding_news.png',
                title: 'Create & Earn',
                subtitle:
                    'Share your stories, news, and opinions with the world — get rewarded for every engagement.',
                color: Color(0xFFE3F2FD), // light blue background
              ),
              _OnboardingPage(
                image: 'assets/images/onboarding_ride.png',
                title: 'Book a Ride',
                subtitle:
                    'Get fast, reliable, and shared affordable rides at your fingertips anytime, anywhere.',
                color: Color(0xFFE3F2FD), // light blue
              ),

              _OnboardingPage(
                image: 'assets/images/onboarding_driver.png',
                title: 'Drive & Earn',
                subtitle:
                    'Become a driver and earn money on your own schedule with every completed trip.',
                color: Color(0xFFFFF3E0), // warm orange
              ),

              _OnboardingPage(
                image: 'assets/images/onboarding_safety.png',
                title: 'Safe & Secure',
                subtitle:
                    'Enjoy peace of mind with real-time tracking, verified drivers, and 24/7 support.',
                color: Color(0xFFF1F8E9), // light green
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(_currentPage == 2 ? "" : "SKIP"),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Theme.of(context).colorScheme.primary,
                    dotColor: Colors.grey.shade300,
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    if (_currentPage == 2) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(_currentPage == 2 ? "GET STARTED" : "NEXT"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET UPDATED ---
// This widget is now updated to use a Stack for a full background image effect.
class _OnboardingPage extends StatelessWidget {
  final String image, title, subtitle;

  const _OnboardingPage({
    required this.image,
    required this.title,
    required this.subtitle,
    required Color color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Background Image
        Image.asset(
          image,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        // Layer 2: Gradient Overlay for Readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        // Layer 3: Text Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 120.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
