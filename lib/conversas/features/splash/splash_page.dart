import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class SplashPage extends ConsumerStatefulWidget {
  static SplashPage builder(BuildContext context, GoRouterState state) =>
      const SplashPage();
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    ref.read(splashTimerProvider.notifier).start();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;

    return Scaffold(
      body: SizedBox(
        width: deviceSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceSize.height * 0.15,
              width: deviceSize.width * 0.4,
              child: const Image(
                image: AppAssets.logo,
              ).animate().fade(delay: 300.ms, duration: 900.ms).fade(),
            ),
            AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: [
                //Text(
                TyperAnimatedText(
                  context.l10n.appTitle,
                  textStyle: context.textStyle.titleLarge,
                  speed: const Duration(milliseconds: 80),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
