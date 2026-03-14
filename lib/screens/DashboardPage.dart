import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff6C63FF),
                      Color(0xff8F7CFF),
                      Color(0xff4E9FFF),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                
                child: Row(
                  children: [
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1704748082614-8163a88e56b8"),
                    ),

                    const SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hello Abram 👋",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Ready to study?",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "🔥 5",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: const [
                    ActionCard(
                      icon: Icons.quiz,
                      title: "Start Quiz",
                      color: Colors.orange,
                    ),
                    ActionCard(
                      icon: Icons.smart_toy,
                      title: "Ask AI",
                      color: Colors.blue,
                    ),
                    ActionCard(
                      icon: Icons.note,
                      title: "Notes",
                      color: Colors.green,
                    ),
                    ActionCard(
                      icon: Icons.bar_chart,
                      title: "Progress",
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// Study Progress
              sectionTitle("Study Progress"),

              progressCard("Data Structures", 0.8),
              progressCard("Algorithms", 0.6),
              progressCard("Operating Systems", 0.4),

              const SizedBox(height: 20),

              /// Recommended
              sectionTitle("Recommended"),

              recommendCard("Binary Trees Quiz"),
              recommendCard("Heap Practice"),
              recommendCard("Sorting Algorithms"),

              const SizedBox(height: 20),

              /// Achievements
              sectionTitle("Achievements"),

              achievementCard(
                "7 Day Streak",
                Icons.local_fire_department,
                Colors.orange,
              ),

              achievementCard(
                "Quiz Master",
                Icons.emoji_events,
                Colors.amber,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

Widget progressCard(String title, double progress) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    ),
  );
}

Widget recommendCard(String title) {
  return ListTile(
    leading: const Icon(Icons.school),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  );
}

Widget achievementCard(String title, IconData icon, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}