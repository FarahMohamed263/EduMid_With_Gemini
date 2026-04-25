import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class Slide {
  final String title;
  final String description;
  final IconData icon;

  Slide({
    required this.title,
    required this.description,
    required this.icon,
  });
}

final List<Slide> slides = [
  Slide(
    title: "Study Smarter, Not Harder",
    description:
    "Harness the power of AI to transform your learning experience and achieve academic excellence.",
    icon: Icons.auto_awesome,
  ),
  Slide(
    title: "Turn PDFs into Quizzes Instantly",
    description:
    "Upload your study materials and let AI generate personalized quizzes in seconds.",
    icon: Icons.article,
  ),
  Slide(
    title: "Track Your Progress with AI",
    description:
    "Get intelligent insights into your learning patterns and areas for improvement.",
    icon: Icons.trending_up,
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int currentSlide = 0;

  late AnimationController mainController;
  late AnimationController glowController;
  late AnimationController floatingController;

  @override
  void initState() {
    super.initState();

    mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    mainController.dispose();
    glowController.dispose();
    floatingController.dispose();
    super.dispose();
  }

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void handleNext() {
    if (currentSlide < slides.length - 1) {
      setState(() {
        currentSlide++;
        mainController.forward(from: 0); // restart animation
      });
    } else {
      finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = slides[currentSlide];

    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: Stack(
        children: [
          /// SKIP
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: finishOnboarding,
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          /// MAIN CONTENT
          Center(
            child: AnimatedBuilder(
              animation: mainController,
              builder: (_, __) {
                double slideX = 100 * (1 - mainController.value);

                return Opacity(
                  opacity: mainController.value,
                  child: Transform.translate(
                    offset: Offset(slideX, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// CIRCLE (Illustration)
                        AnimatedBuilder(
                          animation: glowController,
                          builder: (_, __) {
                            return Container(
                              width: 256,
                              height: 256,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.withOpacity(0.1),
                                    Colors.blue.withOpacity(0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(
                                        0.1 + glowController.value * 0.1),
                                    blurRadius: 40 +
                                        glowController.value * 20,
                                  )
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    slide.icon,
                                    size: 80,
                                    color: Colors.blueAccent,
                                  ),

                                  /// TOP RIGHT FLOAT
                                  Positioned(
                                    top: -16,
                                    right: -16,
                                    child: AnimatedBuilder(
                                      animation: floatingController,
                                      builder: (_, __) {
                                        double scale = 1 +
                                            (sin(floatingController.value *
                                                pi) *
                                                0.5);

                                        return Transform.scale(
                                          scale: scale,
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  /// BOTTOM LEFT FLOAT
                                  Positioned(
                                    bottom: -24,
                                    left: -24,
                                    child: AnimatedBuilder(
                                      animation: floatingController,
                                      builder: (_, __) {
                                        double scale = 1 +
                                            (sin(floatingController.value *
                                                pi) *
                                                0.3);

                                        return Transform.scale(
                                          scale: scale,
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue
                                                  .withOpacity(0.2),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        /// TITLE + DESC
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              Text(
                                slide.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                slide.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// BOTTOM CONTROLS
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                /// INDICATORS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    slides.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: currentSlide == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: currentSlide == index
                            ? Colors.blue
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// NEXT BUTTON
                ElevatedButton(
                  onPressed: handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSlide == slides.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}