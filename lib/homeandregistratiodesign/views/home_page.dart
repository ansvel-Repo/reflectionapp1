// lib/views/home_page.dart

import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/home_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/add_wallet_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/custom_icon_button.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/panic_button.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/ad_carousel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Placeholders for your other custom widgets/screens
class THomeAppBar extends StatelessWidget {
  const THomeAppBar({super.key});
  @override
  Widget build(BuildContext context) => AppBar(
    title: const Text("Ansvel Home"),
    actions: [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddWalletScreen()),
          );
        },
      ),
    ],
  );
}

class TSearchContainer extends StatelessWidget {
  final String text;
  const TSearchContainer({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: text,
        prefixIcon: const Icon(Icons.search),
      ),
    ),
  );
}

class TSectionHeading extends StatelessWidget {
  final String title;
  final bool showActionButton;
  final Color textColor;
  const TSectionHeading({
    super.key,
    required this.title,
    this.showActionButton = false,
    required this.textColor,
  });
  @override
  Widget build(BuildContext context) => Text(
    title,
    style: TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    textAlign: TextAlign.left,
  );
}

class HomeCategoryServices extends StatelessWidget {
  const HomeCategoryServices({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 80,
    child: Center(child: Text("[Home Category Services]")),
  );
}

class TPrimaryHeaderContainer extends StatelessWidget {
  final Widget child;
  const TPrimaryHeaderContainer({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(bottom: 16),
    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    child: child,
  );
}

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Feedback Screen")));
}

class RefHomePage extends StatelessWidget {
  const RefHomePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Referral Home Page")));
}

class PartnerInformationForm extends StatelessWidget {
  const PartnerInformationForm({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Partner Form")));
}

class DashboardTopCourses extends StatelessWidget {
  final TextTheme txtTheme;
  final bool isDark;
  const DashboardTopCourses({
    super.key,
    required this.txtTheme,
    required this.isDark,
  });
  @override
  Widget build(BuildContext context) =>
      const Card(child: ListTile(title: Text("Top Courses Placeholder")));
}

class AppThemeData {
  static const Color primary50 = Color(0xFFE8EAF6);
}

class TSizes {
  static const double spaceBtwSections = 32.0;
  static const double spaceBtwItems = 16.0;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final home = Provider.of<HomeController>(context);
    final user = auth.currentUser;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : AppThemeData.primary50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(isDark, context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  home.isLoadingAds
                      ? const Center(child: CircularProgressIndicator())
                      : AdCarousel(slides: home.adSlides),
                  // The service sections can be added here if needed
                  _buildPartnershipBannerSection(isDark, context),
                  _buildTopCoursesSection(Theme.of(context).textTheme, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const PanicButton(),
    );
  }

  Widget _buildHeaderSection(bool isDark, BuildContext context) {
    return TPrimaryHeaderContainer(
      child: Column(
        children: [
          const THomeAppBar(),
          const SizedBox(height: TSizes.spaceBtwSections - 10),
          const TSearchContainer(text: 'Search for Services'),
          const SizedBox(height: TSizes.spaceBtwItems),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                TSectionHeading(
                  title: 'Popular Services',
                  showActionButton: false,
                  textColor: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const HomeCategoryServices(),
                _buildActionButtonsSection(isDark, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection(bool isDark, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeedbackScreen()),
            ),
            backgroundColor: Colors.greenAccent,
            title: 'Feedback',
            icon: Icons.feedback,
            textColor: Colors.black,
          ),
          CustomIconButton(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RefHomePage()),
            ),
            backgroundColor: Colors.white,
            title: 'Referral',
            icon: Icons.share,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildPartnershipBannerSection(bool isDark, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/advert1background.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade800,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 10,
            offset: Offset(-4, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/thinkingemoji.png",
                  width: 100,
                  height: 100,
                ),
                Expanded(
                  child: Text(
                    "Do you run a financial service or tech solution? Integrate with us and reach millions of users.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CustomIconButton(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PartnerInformationForm(),
                  ),
                ),
                backgroundColor: Colors.greenAccent,
                title: 'Contact Us',
                icon: Icons.phone,
                textColor: Colors.black,
                width: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCoursesSection(TextTheme textTheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const Divider(),
          DashboardTopCourses(txtTheme: textTheme, isDark: isDark),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
