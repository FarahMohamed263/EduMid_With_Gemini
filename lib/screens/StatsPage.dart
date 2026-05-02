import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:ai_study_app/app_palette.dart';
import '../l10n/app_localizations.dart';
import '../services/study_hour_service.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final performanceData = [65.0, 70.0, 72.0, 78.0];

  final achievements = [
    {"name": "First Quiz", "icon": "🎯", "earned": true},
    {"name": "7-Day Streak", "icon": "🔥", "earned": true},
    {"name": "10 PDFs", "icon": "📚", "earned": true},
    {"name": "Speed Master", "icon": "⚡", "earned": false},
    {"name": "Perfect Score", "icon": "💯", "earned": false},
  ];

  Widget _card({required Widget child, bool highlight = false}) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight ? palette.primary.withOpacity(0.5) : palette.border,
        ),
        boxShadow: [
          BoxShadow(
            color: highlight
                ? palette.primary.withOpacity(0.3)
                : Colors.black.withOpacity(0.4),
            blurRadius: 25,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _quickStat(IconData icon, String label, String value) {
    final palette = AppPalette.of(context);
    return Container(
      width: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(color: palette.primary.withOpacity(0.3), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: palette.primary),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _skill(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Widget _achievement(Map item) {
    bool earned = item["earned"];
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: earned
            ? const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
              )
            : null,
        color: earned ? null : const Color(0xFF1F2937),
        boxShadow: earned
            ? [BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 20)]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item["icon"], style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 6),
          Text(
            item["name"],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: earned ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _insight(String text) {
    final palette = AppPalette.of(context);
    return Row(
      children: [
        Icon(Icons.auto_awesome, color: palette.primary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: TextStyle(color: palette.textPrimary)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          /// Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [palette.bgTop, palette.bgBottom, palette.bgTop],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// particles
          ...List.generate(40, (i) {
            final r = Random(i);
            return Positioned(
              left: r.nextDouble() * MediaQuery.of(context).size.width,
              top: r.nextDouble() * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),

          SafeArea(
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.appTitle,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader =
                                    LinearGradient(
                                      colors: [
                                        palette.primary,
                                        const Color(0xFF8B5CF6),
                                      ],
                                    ).createShader(
                                      const Rect.fromLTWH(0, 0, 200, 70),
                                    ),
                            ),
                          ),
                          Text(
                            localizations.yourSmartCompanion,
                            style: TextStyle(color: palette.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [palette.primary, const Color(0xFF8B5CF6)],
                          ),
                        ),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                /// CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        /// PERFORMANCE
                        _card(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    localizations.overallPerformance,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.trending_up,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 110,
                                        height: 110,
                                        child: CircularProgressIndicator(
                                          value: 0.78,
                                          strokeWidth: 10,
                                          color: palette.primary,
                                          backgroundColor: palette.primary
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      Text(
                                        "78%",
                                        style: TextStyle(
                                          color: palette.textPrimary,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: SizedBox(
                                      height: 100,
                                      child: LineChart(
                                        LineChartData(
                                          gridData: FlGridData(show: false),
                                          titlesData: FlTitlesData(show: false),
                                          borderData: FlBorderData(show: false),
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: const [
                                                FlSpot(0, 65),
                                                FlSpot(1, 70),
                                                FlSpot(2, 72),
                                                FlSpot(3, 78),
                                              ],
                                              isCurved: true,
                                              color: palette.primary,
                                              barWidth: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// QUICK STATS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _quickStat(Icons.gps_fixed, "Level", "12"),
                            StreamBuilder<String>(
                              stream:
                                  StudyHourService.formattedStudyHoursStream(),
                              builder: (context, snapshot) {
                                final studyHours = snapshot.data ?? '0h';
                                return _quickStat(
                                  Icons.timer,
                                  "Hours",
                                  studyHours,
                                );
                              },
                            ),
                            _quickStat(Icons.bar_chart, "Score", "94%"),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// STRENGTH / WEAKNESS
                        _card(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Strengths",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    _skill("OOP", Colors.green),
                                    _skill("Algorithms", Colors.green),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Weakness",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    _skill("Graphs", Colors.orange),
                                    _skill("DP", Colors.orange),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ACHIEVEMENTS
                        _card(
                          child: SizedBox(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: achievements
                                  .map((e) => _achievement(e))
                                  .toList(),
                            ),
                          ),
                        ),

                        /// INSIGHTS
                        _card(
                          highlight: true,
                          child: Column(
                            children: [
                              _insight("Focus more on Data Structures"),
                              _insight("Performance improved by 15%"),
                              _insight("You're close to Level 15"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
