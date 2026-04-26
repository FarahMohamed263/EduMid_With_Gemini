import 'dart:math';
import 'package:flutter/material.dart';

class AcademicScreen extends StatefulWidget {
  const AcademicScreen({super.key});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen>
    with TickerProviderStateMixin {
  final Map<String, String> formData = {
    'university': '',
    'faculty': '',
    'major': '',
    'academicYear': '',
    'gpa': '',
  };

  String gpaError = '';
  String focusedField = '';

  void handleGpaChange(String value) {
    final regex = RegExp(r'^\d+\.\d$');

    if (value.isNotEmpty && regex.hasMatch(value)) {
      setState(() {
        formData['gpa'] = value;

        if (value.isNotEmpty) {
          final numValue = double.tryParse(value);
          if (numValue == null) {
            gpaError = 'Please enter a valid number';
          } else if (numValue < 0 || numValue > 4) {
            gpaError = 'GPA must be between 0.0 and 4.0';
          } else {
            gpaError = '';
          }
        } else {
          gpaError = '';
        }
      });
    }
  }

  bool get isGpaValid {
    final gpa = formData['gpa']!;
    final val = double.tryParse(gpa);
    return gpa.isNotEmpty &&
        gpaError.isEmpty &&
        val != null &&
        val >= 0 &&
        val <= 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F2A),
      body: Stack(
        children: [
          // 🌌 Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B0F2A), Color(0xFF050816)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ✨ Particles
          const Particles(),

          // 📄 Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  const SizedBox(height: 32),
                  formCard(),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Powered by EduMind AI',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Academic Information',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Text(
          'Your educational details',
          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      ],
    );
  }

  Widget formCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField('University Name', 'university', 'Enter your university'),
          const SizedBox(height: 16),
          buildField('Faculty / College', 'faculty', 'Enter your faculty'),
          const SizedBox(height: 16),
          buildField('Major / Field of Study', 'major', 'Enter your major'),
          const SizedBox(height: 16),
          buildDropdown(),
          const SizedBox(height: 16),
          gpaField(),
          const SizedBox(height: 28),
          saveButton(),
        ],
      ),
    );
  }

  Widget buildField(String label, String key, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: (v) => formData[key] = v,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF4DA3FF),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Academic Year',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: const Color(0xff0B0F2A),
            value: formData['academicYear']!.isEmpty
                ? null
                : formData['academicYear'],
            items: const [
              DropdownMenuItem(value: '1', child: Text('Year 1')),
              DropdownMenuItem(value: '2', child: Text('Year 2')),
              DropdownMenuItem(value: '3', child: Text('Year 3')),
              DropdownMenuItem(value: '4', child: Text('Year 4')),
              DropdownMenuItem(value: 'graduate', child: Text('Graduate')),
            ],
            onChanged: (v) =>
                setState(() => formData['academicYear'] = v ?? ''),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              isDense: true,
            ),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget gpaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GPA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: handleGpaChange,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'GPA (0.0 - 4.0)',
                hintStyle: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF4DA3FF),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            if (isGpaValid)
              const Positioned(
                right: 15,
                top: 16,
                child: Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
          ],
        ),
        if (gpaError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              gpaError,
              style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Save academic information to database or state
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Academic information saved!')),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4DA3FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Save Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ✨ Particles
class Particles extends StatefulWidget {
  const Particles({super.key});

  @override
  State<Particles> createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return CustomPaint(painter: ParticlePainter(), child: Container());
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final rand = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue.withOpacity(0.3);

    for (int i = 0; i < 20; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
