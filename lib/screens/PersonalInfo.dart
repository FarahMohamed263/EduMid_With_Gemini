import 'dart:math';

import 'package:ai_study_app/app_palette.dart';
import 'package:ai_study_app/screens/AcademicInfo.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen>
    with TickerProviderStateMixin {
  final Map<String, String> formData = {
    'fullName': '',
    'username': '',
    'age': '',
    'phoneNumber': '',
    'sex': '',
  };

  String ageError = '';
  String phoneError = '';
  String sexError = '';
  final Random random = Random();

  bool get isAgeValid {
    final age = int.tryParse(formData['age'] ?? '');
    return age != null && age >= 1 && age <= 120 && ageError.isEmpty;
  }

  bool get isPhoneValid {
    final phone = formData['phoneNumber'] ?? '';
    return phone.isNotEmpty && phoneError.isEmpty;
  }

  bool get isSexValid {
    return (formData['sex'] ?? '').isNotEmpty;
  }

  void handleAgeChange(String value) {
    setState(() {
      formData['age'] = value;

      if (value.isEmpty) {
        ageError = '';
      } else {
        final age = int.tryParse(value);
        if (age == null) {
          ageError = AppLocalizations.of(context)!.pleaseEnterValidAge;
        } else if (age < 1 || age > 120) {
          ageError = AppLocalizations.of(context)!.ageMustBeBetween;
        } else {
          ageError = '';
        }
      }
    });
  }

  void handlePhoneChange(String value) {
    setState(() {
      formData['phoneNumber'] = value;

      if (value.isEmpty) {
        phoneError = '';
      } else if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(value)) {
        phoneError = AppLocalizations.of(context)!.pleaseEnterValidPhone;
      } else {
        phoneError = '';
      }
    });
  }

  void handleSexChange(String value) {
    setState(() {
      formData['sex'] = value;
      sexError = value.isEmpty
          ? AppLocalizations.of(context)!.pleaseSelectYourSex
          : '';
    });
  }

  void goToAcademicInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AcademicScreen()),
    );
  }

  void showSexPicker() {
    final palette = AppPalette.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: palette.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(palette.isDark ? 0.35 : 0.10),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: palette.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.selectSex,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSexOption(
                  'male',
                  AppLocalizations.of(context)!.male,
                  Icons.male_rounded,
                ),
                const SizedBox(height: 10),
                _buildSexOption(
                  'female',
                  AppLocalizations.of(context)!.female,
                  Icons.female_rounded,
                ),
                const SizedBox(height: 10),
                _buildSexOption(
                  'other',
                  AppLocalizations.of(context)!.other,
                  Icons.person_rounded,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSexOption(String value, String label, IconData icon) {
    final palette = AppPalette.of(context);
    final isSelected = formData['sex'] == value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          handleSexChange(value);
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? palette.primary.withOpacity(palette.isDark ? 0.20 : 0.12)
                : palette.surfaceAlt,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? palette.primary : palette.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.primary.withOpacity(
                    palette.isDark ? 0.18 : 0.12,
                  ),
                ),
                child: Icon(icon, color: palette.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: palette.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [palette.bgTop, palette.bgBottom],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const Particles(),
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
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.poweredByEduMindAI,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                      ),
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
    final palette = AppPalette.of(context);
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
              color: palette.surface,
              border: Border.all(color: palette.border),
            ),
            child: Icon(
              Icons.arrow_back,
              color: palette.textSecondary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.personalInformation,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: palette.textPrimary,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.tellUsAboutYourself,
          style: TextStyle(color: palette.textSecondary, fontSize: 14),
        ),
      ],
    );
  }

  Widget formCard() {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(palette.isDark ? 0.24 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            AppLocalizations.of(context)!.fullName,
            'fullName',
            AppLocalizations.of(context)!.enterYourFullName,
          ),
          const SizedBox(height: 16),
          buildField(
            AppLocalizations.of(context)!.username,
            'username',
            AppLocalizations.of(context)!.enterYourUsername,
          ),
          const SizedBox(height: 16),
          buildAgeField(),
          const SizedBox(height: 16),
          buildPhoneField(),
          const SizedBox(height: 16),
          buildSexDropdown(),
          const SizedBox(height: 28),
          nextButton(),
        ],
      ),
    );
  }

  Widget buildField(String label, String key, String placeholder) {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: (value) => setState(() => formData[key] = value),
          style: TextStyle(color: palette.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: palette.textSecondary, fontSize: 14),
            filled: true,
            fillColor: palette.surfaceAlt,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.primary, width: 1.5),
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

  Widget buildAgeField() {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.age,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: handleAgeChange,
          style: TextStyle(color: palette.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterYourAge,
            hintStyle: TextStyle(color: palette.textSecondary, fontSize: 14),
            filled: true,
            fillColor: palette.surfaceAlt,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        if (ageError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              ageError,
              style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget buildPhoneField() {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.phoneNumber,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.phone,
          onChanged: handlePhoneChange,
          style: TextStyle(color: palette.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterYourPhoneNumber,
            hintStyle: TextStyle(color: palette.textSecondary, fontSize: 14),
            filled: true,
            fillColor: palette.surfaceAlt,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        if (phoneError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              phoneError,
              style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget buildSexDropdown() {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.sex,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: showSexPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: palette.surfaceAlt,
              border: Border.all(
                color: sexError.isNotEmpty
                    ? const Color(0xFFEF4444)
                    : palette.border,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: palette.primary.withOpacity(
                      palette.isDark ? 0.18 : 0.12,
                    ),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: palette.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    formData['sex']!.isEmpty
                        ? AppLocalizations.of(context)!.chooseYourSex
                        : formData['sex']![0].toUpperCase() +
                              formData['sex']!.substring(1),
                    style: TextStyle(
                      color: formData['sex']!.isEmpty
                          ? palette.textSecondary
                          : palette.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: palette.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (sexError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              sexError,
              style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget nextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: goToAcademicInfo,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.of(context).primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          AppLocalizations.of(context)!.next,
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
