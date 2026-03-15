import 'package:ai_study_app/screens/DashboardPage.dart';
import 'package:ai_study_app/screens/ProfilePage.dart';
import 'package:ai_study_app/screens/al-chat.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// HEADER
                Row(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            "https://avatars.githubusercontent.com/u/12345678?v=4",
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, bero! 👋",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Ready to learn today?",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_none),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// AI APP DESCRIPTION
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xff667eea), Color(0xff764ba2)],
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🎓 AI Study Assistant",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Your smart study companion! Upload PDF files, ask questions, generate quizzes, and get explanations using AI.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// AI STUDY BUTTON
                buildMainButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    );
                  },
                  icon: Icons.smart_toy,
                  title: "AI Study",
                  subtitle: "Chat with AI assistant",
                ),

                const SizedBox(height: 15),

                /// DASHBOARD BUTTON
                buildMainButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    );
                  },
                  icon: Icons.dashboard,
                  title: "Dashboard",
                  subtitle: "Track your learning progress",
                ),

                const SizedBox(height: 15),

                /// PROFILE BUTTON
                buildMainButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },

                  icon: Icons.person,
                  title: "Profile",
                  subtitle: "User settings and account",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// BUTTON WIDGET
  Widget buildMainButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xff667eea),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
