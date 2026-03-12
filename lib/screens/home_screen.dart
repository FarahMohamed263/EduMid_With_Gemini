import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.grey[100],

      

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.purple,
                    Colors.teal
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Hello, Abram 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Ready to ace your studies today?",
                        style: TextStyle(color: Colors.white70),
                      )
                    ],
                  ),

                  IconButton(
                    icon: const Icon(Icons.flag, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, "/profile");
                    },
                  )
                ],
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -80),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    /// TODAY PROGRESS
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Today's Progress",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("March 2, 2026",
                                    style: TextStyle(color: Colors.grey))
                              ],
                            ),

                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: const [
                                ProgressItem("3.5", "Hours"),
                                ProgressItem("12", "Quizzes"),
                                ProgressItem("85%", "Accuracy"),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Daily Goal",
                                        style: TextStyle(color: Colors.grey)),
                                    Text("70% Complete")
                                  ],
                                ),

                                const SizedBox(height: 8),

                                LinearProgressIndicator(
                                  value: 0.7,
                                  minHeight: 10,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// STUDY PLAN
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [

                            Text(
                              "Today's Study Plan",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 15),

                            StudyItem(
                              title: "Computer Science - Data Structures",
                              time: "09:00 - 10:30 AM",
                            ),

                            StudyItem(
                              title: "Mathematics - Calculus II",
                              time: "11:00 - 12:30 PM",
                            ),

                            StudyItem(
                              title: "Physics - Quantum Mechanics",
                              time: "02:00 - 03:30 PM",
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// FOCUS AREAS
                    Card(
                      color: Colors.red[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Focus Areas",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 15),

                            const FocusItem(
                                subject: "Organic Chemistry",
                                percent: 0.45),

                            const FocusItem(
                                subject: "Linear Algebra",
                                percent: 0.62),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/weakness");
                                },
                                child: const Text("Review Weak Areas"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // /// QUICK ACTIONS
                    // GridView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: quickActions.length,
                    //   gridDelegate:
                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     crossAxisSpacing: 15,
                    //     mainAxisSpacing: 15,
                    //     childAspectRatio: 1.2,
                    //   ),
                    //   itemBuilder: (context, index) {

                    //     final action = quickActions[index];

                    //     return GestureDetector(
                    //       onTap: () {
                    //         Navigator.pushNamed(
                    //             context, action["route"] as String);
                    //       },

                    //       child: Container(
                    //         padding: const EdgeInsets.all(16),
                    //         decoration: BoxDecoration(
                    //           gradient: LinearGradient(
                    //             colors: [
                    //               action["color1"] as Color,
                    //               action["color2"] as Color
                    //             ],
                    //           ),
                    //           borderRadius: BorderRadius.circular(20),
                    //         ),

                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [

                    //             Icon(
                    //               action["icon"] as IconData,
                    //               color: Colors.white,
                    //               size: 32,
                    //             ),

                    //             const SizedBox(height: 10),

                    //             Text(
                    //               action["label"] as String,
                    //               style: const TextStyle(
                    //                   color: Colors.white,
                    //                   fontWeight: FontWeight.bold),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProgressItem extends StatelessWidget {
  final String value;
  final String label;

  const ProgressItem(this.value, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey))
      ],
    );
  }
}

class StudyItem extends StatelessWidget {
  final String title;
  final String time;

  const StudyItem({required this.title, required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.circle, size: 10),
        title: Text(title),
        subtitle: Text(time),
      ),
    );
  }
}

class FocusItem extends StatelessWidget {
  final String subject;
  final double percent;

  const FocusItem({required this.subject, required this.percent, super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(subject),
            Text("${(percent * 100).toInt()}%")
          ],
        ),

        const SizedBox(height: 6),

        LinearProgressIndicator(value: percent),

        const SizedBox(height: 12),
      ],
    );
  }
}
