import 'package:ai_study_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 80),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff667eea),
                    Color(0xff764ba2),
                    Color(0xff6B73FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: Column(
                children: [
                  /// BACK BUTTON
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

                  const SizedBox(height: 10),

                  /// PROFILE IMAGE
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "https://plus.unsplash.com/premium_photo-1661475730231-353be703c97e?q=80&w=1331&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Kyrillos Elia",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Text(
                    "Computer Science Major",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

           
            /// Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  StatCard(title: "GPA", value: "3.8"),
                  StatCard(title: "Quizzes", value: "156"),
                  StatCard(title: "Streak", value: "28"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// Achievements
            sectionTitle("Achievements"),

            achievementCard(
              icon: Icons.emoji_events,
              title: "7-Day Streak",
              subtitle: "Keep going!",
              color: Colors.orange,
            ),

            achievementCard(
              icon: Icons.school,
              title: "Quiz Master",
              subtitle: "100+ quizzes completed",
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            /// Settings
            sectionTitle("Account"),

            settingsTile(Icons.person, "Edit Profile"),
            settingsTile(Icons.email, "Email Settings"),
            settingsTile(Icons.school, "Academic Information"),

            const SizedBox(height: 20),

            sectionTitle("Preferences"),

            settingsTile(Icons.notifications, "Notifications"),
            settingsTile(Icons.dark_mode, "Appearance"),
            settingsTile(Icons.settings, "App Settings"),

            const SizedBox(height: 20),

            /// Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  LoginScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Log Out"),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Smart Study AI v1.0.0",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// Stats Card
class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

/// Achievement Card
Widget achievementCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Settings Tile
Widget settingsTile(IconData icon, String title) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
  );
}

/// Section Title
Widget sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}



















// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7F9FC),

//       body: SingleChildScrollView(
//         child: Column(
//           children: [

//             /// HEADER
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.only(top: 60, bottom: 80),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xff667eea),
//                     Color(0xff764ba2),
//                     Color(0xff6B73FF),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),

//               child: Column(
//                 children: [

//                   /// BACK BUTTON
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: IconButton(
//                         icon: const Icon(Icons.arrow_back, color: Colors.white),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   /// PROFILE IMAGE
//                   const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(
//                       "https://plus.unsplash.com/premium_photo-1661475730231-353be703c97e?q=80&w=1331&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   const Text(
//                     "Kyrillos Elia",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const Text(
//                     "Computer Science Major",
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// STATS
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   StatCard(title: "3.8", subtitle: "GPA"),
//                   StatCard(title: "156", subtitle: "Quizzes"),
//                   StatCard(title: "28", subtitle: "Streak"),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 25),

//             /// ACHIEVEMENTS
//             buildSection(
//               title: "Recent Achievements",
//               child: Column(
//                 children: const [
//                   AchievementCard(
//                     icon: Icons.emoji_events,
//                     title: "7-Day Streak",
//                     subtitle: "Keep going!",
//                   ),
//                   AchievementCard(
//                     icon: Icons.school,
//                     title: "Quiz Master",
//                     subtitle: "100+ quizzes completed",
//                   ),
//                 ],
//               ),
//             ),

//             /// ACCOUNT
//             buildSection(
//               title: "Account",
//               child: Column(
//                 children: const [
//                   SettingItem(icon: Icons.person, text: "Edit Profile"),
//                   SettingItem(icon: Icons.email, text: "Email Settings"),
//                   SettingItem(icon: Icons.school, text: "Academic Information"),
//                 ],
//               ),
//             ),

//             /// PREFERENCES
//             buildSection(
//               title: "Preferences",
//               child: Column(
//                 children: const [
//                   SettingItem(icon: Icons.notifications, text: "Notifications"),
//                   SettingItem(icon: Icons.dark_mode, text: "Appearance"),
//                   SettingItem(icon: Icons.settings, text: "App Settings"),
//                 ],
//               ),
//             ),

//             /// LOGOUT
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red.shade50,
//                   foregroundColor: Colors.red,
//                   minimumSize: const Size(double.infinity, 55),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/login");
//                 },
//                 icon: const Icon(Icons.logout),
//                 label: const Text("Log Out"),
//               ),
//             ),

//             const Text(
//               "Smart Study AI v1.0.0",
//               style: TextStyle(color: Colors.grey),
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   /// SECTION WIDGET
//   static Widget buildSection({required String title, required Widget child}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Container(
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             child,
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// STAT CARD
// class StatCard extends StatelessWidget {
//   final String title;
//   final String subtitle;

//   const StatCard({super.key, required this.title, required this.subtitle});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xff667eea),
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             subtitle,
//             style: const TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// ACHIEVEMENT CARD
// class AchievementCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;

//   const AchievementCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: const Color(0xff667eea),
//         child: Icon(icon, color: Colors.white),
//       ),
//       title: Text(title),
//       subtitle: Text(subtitle),
//       trailing: const Icon(Icons.chevron_right),
//     );
//   }
// }

// /// SETTINGS ITEM
// class SettingItem extends StatelessWidget {
//   final IconData icon;
//   final String text;

//   const SettingItem({super.key, required this.icon, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.grey),
//       title: Text(text),
//       trailing: const Icon(Icons.chevron_right),
//     );
//   }
// }