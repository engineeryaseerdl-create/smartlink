import 'dart:async';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int currentIndex = 0;
  Timer? autoSlideTimer;

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    fadeController.forward();

    _startAutoSlide();
  }

  void _startAutoSlide() {
    autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && currentIndex < pages.length - 1) {
        nextPage(auto: true);
      }
    });
  }

  @override
  void dispose() {
    autoSlideTimer?.cancel();
    _controller.dispose();
    fadeController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> pages = [
    {
      "image": "images/connect.png",
      "title": "Welcome to SmartLink",
      "subtitle": "Nigeria's #1 marketplace connecting buyers, sellers, and riders across all states"
    },
    {
      "image": "images/track.png",
      "title": "Shop from Local Sellers",
      "subtitle": "Discover amazing products from verified sellers in your area with competitive prices"
    },
    {
      "image": "images/deliver.png",
      "title": "Fast Okada Delivery",
      "subtitle": "Get your orders delivered quickly by trusted riders in your neighborhood"
    },
  ];

  void nextPage({bool auto = false}) {
    if (!mounted) return;

    fadeController.reset();
    fadeController.forward();

    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    } else if (!auto) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void skip() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // BOTTOM WAVE BACKGROUND LAYER
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: const Color(0xFFF88F3A),
              ),
            ),
          ),

          // MAIN CONTENT
          SafeArea(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                if (!mounted) return;
                setState(() => currentIndex = index);
                fadeController.reset();
                fadeController.forward();
              },
              itemBuilder: (_, index) {
                final item = pages[index];

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // SKIP BUTTON
                        Align(
                          alignment: Alignment.centerRight,
                          child: currentIndex < pages.length - 1
                              ? TextButton(
                                  onPressed: skip,
                                  child: const Text(
                                    "Skip",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFF88F3A),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : const SizedBox(height: 40),
                        ),

                        const SizedBox(height: 40),

                        // IMAGE with floating effect
                        Container(
                          height: 250,
                          child: AnimatedScale(
                            scale: currentIndex == index ? 1.0 : 0.8,
                            duration: const Duration(milliseconds: 300),
                            child: Image.asset(
                              'assets/${item["image"]!}',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF88F3A).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                    color: Color(0xFFF88F3A),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // TITLE
                        Text(
                          item["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFF88F3A),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // SUBTITLE
                        Text(
                          item["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // PROGRESS BAR
                        Container(
                          height: 4,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 60 * ((currentIndex + 1) / pages.length),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: const Color(0xFFF88F3A),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ACTION BUTTON
                        ElevatedButton(
                          onPressed: nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF88F3A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                            shadowColor: const Color(0xFFF88F3A).withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentIndex == pages.length - 1 ? 'Get Started' : 'Next',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////
// WAVE CLIPPER (BOTTOM WAVE)
//////////////////////////////////

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;

    // Start at top-left
    path.lineTo(0, h * 0.75);

    // Gentle wave going down then up towards the right
    path.quadraticBezierTo(
      w * 0.25, h * 0.65, // control point
      w * 0.50, h * 0.72, // end point
    );

    path.quadraticBezierTo(
      w * 0.75, h * 0.80,
      w, h * 0.70,
    );

    // Right edge up to the top-right corner
    path.lineTo(w, 0);

    // Close back to origin
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double h = size.height;
    double w = size.width;

    // Start from bottom-left
    path.lineTo(0, h);
    path.lineTo(w, h);
    
    // Create wave from right to left (bottom wave)
    path.lineTo(w, h * 0.3);
    
    // First wave curve
    path.quadraticBezierTo(
      w * 0.75,
      h * 0.1,
      w * 0.5,
      h * 0.25,
    );
    
    // Second wave curve
    path.quadraticBezierTo(
      w * 0.25,
      h * 0.4,
      0,
      h * 0.2,
    );
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}