// import 'package:ansvel/conversas/common/common.dart';
// import 'package:ansvel/conversas/config/config.dart';
// import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class DisplayBannerAd extends StatefulWidget {
//   const DisplayBannerAd({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _DisplayBannerAdState();
// }
//
// class _DisplayBannerAdState extends State<DisplayBannerAd> {
//   BannerAd? _bannerAd;
//
//   @override
//   void initState() {
//     BannerAd(
//       adUnitId: AdHelper.bannerAddUnitId,
//       request: const AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: ((ad) {
//           setState(() {
//             _bannerAd = ad as BannerAd;
//           });
//         }),
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//         },
//       ),
//     ).load();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (_bannerAd != null)
//           Container(
//             height: _bannerAd!.size.height.toDouble(),
//             width: context.deviceSize.width,
//             decoration: BoxDecoration(
//               color: context.colorScheme.inversePrimary,
//               borderRadius: AppBorders.allSmall,
//             ),
//             child: AdWidget(ad: _bannerAd!),
//           ),
//       ],
//     );
//   }
// }

// Placeholder widget to avoid build errors after commenting out AdMob code
class DisplayBannerAd extends StatelessWidget {
  const DisplayBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
