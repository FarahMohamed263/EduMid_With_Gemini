import 'dart:math';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // ignore: unused_field
  String _expandedFaq = '';
  String _page = 'help'; // 'help' or 'report'
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'id': 'faq1',
      'q': 'How do I upload study materials?',
      'a':
          'Tap the upload button on the home screen, select your files (PDF, images, or documents), and our AI will automatically process and summarize them for you.',
    },
    {
      'id': 'faq2',
      'q': 'How does AI summarization work?',
      'a':
          'Our advanced AI analyzes your study materials, extracts key concepts, and creates concise summaries that help you learn faster and retain information better.',
    },
    {
      'id': 'faq3',
      'q': 'How can I track my progress?',
      'a':
          'Visit the Progress tab to view detailed analytics, study streaks, completed materials, and personalized insights about your learning journey.',
    },
    {
      'id': 'faq4',
      'q': 'How do I reset my password?',
      'a':
          'Go to Settings > Security, tap "Change Password", and follow the instructions. You\'ll receive a verification code via email.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitReport() {
    // placeholder for submission logic
    debugPrint('Reported: ${_titleController.text} - ${_descController.text}');
    _titleController.clear();
    _descController.clear();
    setState(() => _page = 'help');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F2A),
      body: Stack(
        children: [
          // floating particles
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;
                return CustomPaint(painter: _ParticlePainter(t));
              },
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: _page == 'help'
                    ? _buildHelp(context)
                    : _buildReport(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelp(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: const Icon(Icons.arrow_back, color: Color(0xFF60A5FA)),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Help & Support',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "We're here to help you",
                  style: TextStyle(color: Color(0xFF93C5FD)),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        ..._faqs.map((f) {
          final id = f['id']!;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              collapsedIconColor: const Color(0xFF60A5FA),
              iconColor: const Color(0xFF60A5FA),
              title: Row(
                children: [
                  const Icon(Icons.help_outline, color: Color(0xFF60A5FA)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      f['q']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 16, 12),
                  child: Text(
                    f['a']!,
                    style: const TextStyle(color: Color(0xFFBFD7FF)),
                  ),
                ),
              ],
              onExpansionChanged: (open) =>
                  setState(() => _expandedFaq = open ? id : ''),
            ),
          );
        }).toList(),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.06),
                Colors.purple.withOpacity(0.06),
              ],
            ),
            border: Border.all(color: Colors.blue.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Quick Help',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Use the chat to ask questions, upload files to get summaries, and track your progress',
                style: TextStyle(color: Color(0xFFBFD7FF)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.04),
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          onPressed: () => setState(() => _page = 'report'),
          child: Row(
            children: const [
              Icon(Icons.report_problem, color: Colors.redAccent),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Report a Problem',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReport(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _page = 'help'),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF60A5FA)),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Report a Problem',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tell us what went wrong',
          style: TextStyle(color: Color(0xFF93C5FD)),
        ),
        const SizedBox(height: 18),

        TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Brief description of the issue',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descController,
          maxLines: 8,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText:
                'Please provide detailed information about the problem you\'re experiencing...',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _submitReport,
            icon: const Icon(Icons.send),
            label: const Text('Submit Report'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(14),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double t;
  _ParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF3B82F6).withOpacity(0.12);
    final rnd = Random(42);
    for (int i = 0; i < 30; i++) {
      final dx =
          (rnd.nextDouble() * size.width + sin(t * (0.5 + i * 0.02)) * 20) %
          size.width;
      final dy =
          (rnd.nextDouble() * size.height + cos(t * (0.4 + i * 0.015)) * 24) %
          size.height;
      canvas.drawCircle(Offset(dx, dy), 2 + (i % 3).toDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.t != t;
}
