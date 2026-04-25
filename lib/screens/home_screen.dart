import 'package:ai_study_app/screens/ProfilePage.dart';
import 'package:ai_study_app/screens/al-chat.dart';
import 'package:ai_study_app/screens/pdf_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  bool orbExpanded = false;
  int activeNav = 0;

  late final AnimationController _orbController;
  late final AnimationController _pulseController;

  late final Animation<double> _orbAnimationY;
  late final Animation<double> _pulse;
  late final Animation<double> _orbScale;

  @override
  void initState() {
    super.initState();

    // حركة لفوق وتحت
    _orbController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);

    _orbAnimationY = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.easeInOut),
    );

    // Pulse للأيقونات
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Pulse للـ Orb
    _orbScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _orbController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A1A),
      body: Stack(
        children: [
          // ⭐ Stars
          ...List.generate(
            30,
            (i) => Positioned(
              left: random.nextDouble() * MediaQuery.of(context).size.width,
              top: random.nextDouble() * MediaQuery.of(context).size.height,
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(80),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("AI Study",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22)),
                          Text("Your Smart Learning Companion",
                              style: TextStyle(color: Colors.blueAccent)),
                        ],
                      ),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Study Streak
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_fire_department,
                                color: Colors.orange, size: 30),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Study Streak",
                                    style: TextStyle(color: Colors.grey)),
                                Text("15 Days 🔥",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                        Text("Keep it up!",
                            style: TextStyle(color: Colors.orange)),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ORB + ICONS
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        orbExpanded = !orbExpanded;
                      });
                    },
                    child: AnimatedBuilder(
                      animation: Listenable.merge(
                          [_orbController, _pulseController]),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _orbAnimationY.value),
                          child: Transform.scale(
                            scale: _orbScale.value,
                            child: SizedBox(
                              width: 300,
                              height: 220,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  // 🔥 3D ORB
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const RadialGradient(
                                          colors: [
                                            Color(0xFF6EC6FF),
                                            Color(0xFF1E88E5),
                                            Color(0xFF6A1B9A),
                                          ],
                                          center: Alignment(-0.3, -0.3),
                                          radius: 0.9,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withAlpha(150),
                                            blurRadius: 25,
                                            spreadRadius: 5,
                                            offset: const Offset(0, 10),
                                          ),
                                          BoxShadow(
                                            color: Colors.purple.withAlpha(100),
                                            blurRadius: 40,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            top: 20,
                                            left: 30,
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    Colors.white.withAlpha(80),
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.psychology,
                                              color: Colors.white, size: 60),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Icons فوق
                                  if (orbExpanded)
                                    Positioned(
                                      bottom: 140,
                                      child: Row(
                                        children: [
                                          pulseIcon(Icons.chat, "Chat"),
                                          const SizedBox(width: 20),
                                          pulseIcon(Icons.upload, "Upload"),
                                          const SizedBox(width: 20),
                                          pulseIcon(Icons.flag, "Quiz"),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Spacer(),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      statCard(Icons.menu_book, "Level", "12"),
                      statCard(Icons.timer, "Hours", "48h"),
                      statCard(Icons.emoji_events, "Score", "94%"),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: activeNav,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 3) { // Profile icon
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          } else {
            setState(() {
              activeNav = index;
            });
          }
        },
        
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: "Learn"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget pulseIcon(IconData icon, String label) {
  return GestureDetector(
    onTap: () {
      if (label == "Chat") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage()),
        );
      } else if (label == "Upload") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PdfPage ()),
        );
      }
    },
    child: AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulse.value,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withAlpha(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(120),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      },
    ),
  );
}

  Widget statCard(IconData icon, String title, String value) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}