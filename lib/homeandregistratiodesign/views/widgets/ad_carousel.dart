import 'package:ansvel/homeandregistratiodesign/models/ad_slide.dart';
// import 'package:ansvel/models/ad_slide.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdCarousel extends StatelessWidget {
  final List<AdSlide> slides;
  const AdCarousel({super.key, required this.slides});

  void _handleButtonPress(BuildContext context, AdSlide slide) async {
    if (slide.actionType == AdActionType.WebLink) {
      final uri = Uri.tryParse(slide.actionTarget);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not open link: ${slide.actionTarget}")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Navigating to in-app page: ${slide.actionTarget}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
      ),
      items: slides.map((slide) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(slide.imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(slide.title, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(slide.subtitle, style: const TextStyle(fontSize: 16.0, color: Colors.white70)),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FilledButton(
                        onPressed: () => _handleButtonPress(context, slide),
                        child: Text(slide.buttonText),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}