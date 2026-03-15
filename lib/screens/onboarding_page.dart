import 'package:ai_study_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/image_with_fallback.dart';

class Slide {
  final String title;
  final String description;
  final String image;
  final IconData icon;

  Slide({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });
}

final List<Slide> slides = [
  Slide(
    title: "Study Smarter, Not Harder",
    description:
        "Harness the power of AI to transform your learning experience and achieve academic excellence.",
    icon: Icons.auto_awesome,
    image:
        "https://images.unsplash.com/photo-1704748082614-8163a88e56b8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
  ),
  Slide(
    title: "Turn PDFs into Quizzes Instantly",
    description:
        "Upload your study materials and let AI generate personalized quizzes in seconds.",
    icon: Icons.article,
    image:
        "https://images.unsplash.com/photo-1770233621425-5d9ee7a0a700?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
  ),
  Slide(
    title: "Track Your Progress with AI",
    description:
        "Get intelligent insights into your learning patterns and areas for improvement.",
    icon: Icons.trending_up,
    image:
        "https://images.unsplash.com/photo-1758518731027-78a22c8852ec?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentSlide = 0;

  Future<void> finishOnboarding() async {
    // نخزن ان المستخدم شاف الـ onboarding
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    // نروح للـ Login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void handleNext() {
    if (currentSlide < slides.length - 1) {
      setState(() {
        currentSlide++;
      });
    } else {
      finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = slides[currentSlide];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ImageWithFallback(
                              imageUrl: slide.image,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.deepPurple, Colors.purpleAccent],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              slide.icon,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      slide.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      slide.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
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
                            color: currentSlide == index ? Colors.deepPurple : Colors.black12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: handleNext,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSlide == slides.length - 1 ? "Get Started" : "Next",
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: finishOnboarding,
                  child: const Text("Skip"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
