import 'package:ai_study_app/screens/About-info.dart';
import 'package:ai_study_app/screens/Help_Screen.dart';
import 'package:ai_study_app/screens/notifications-screen.dart';

import 'EditProfileScreen .dart';
import 'AcademicInfo.dart';
import 'package:ai_study_app/screens/login_screen.dart';
import 'package:ai_study_app/theme_controller.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _isHoverLogout = false;
  String _selectedLanguage = 'English'; // Default language
  late AnimationController _particleController;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 30; i++) {
      _particles.add(
        Particle(
          id: i,
          x: (i * 37) % 100.0, // Distribute evenly
          y: (i * 73) % 100.0,
          delay: i * 0.2,
          duration: 10 + (i % 10),
        ),
      );
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  Widget _animatedWithFade(Widget child, int delayMs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      key: ValueKey(delayMs),
      builder: (context, value, widget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: Transform.scale(scale: 0.9 + 0.1 * value, child: widget),
          ),
        );
      },
      child: child,
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Select Language',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LanguageOption(
                language: 'English',
                flag: '🇺🇸',
                isSelected: _selectedLanguage == 'English',
                onTap: () {
                  setState(() => _selectedLanguage = 'English');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _LanguageOption(
                language: 'العربية',
                flag: '🇪🇬',
                isSelected: _selectedLanguage == 'العربية',
                onTap: () {
                  setState(() => _selectedLanguage = 'العربية');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgTop = isDark ? const Color(0xFF0B0F2A) : Colors.white;
    final bgBottom = isDark ? const Color(0xFF050816) : const Color(0xFFF8FAFC);
    final panelBg = isDark ? Colors.white.withOpacity(0.04) : Colors.white;
    final panelBorder = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.grey.shade300;
    final subtlePanelBg = isDark
        ? Colors.white.withOpacity(0.05)
        : const Color(0xFFF8FAFC);
    final subtlePanelBorder = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.grey.shade300;
    final primaryBlue = isDark
        ? const Color(0xFF3B82F6)
        : const Color(0xFF2563EB);
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark
        ? const Color(0xFF9CA3AF)
        : Colors.grey.shade700;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgTop, bgBottom],
              ),
            ),
          ),

          // Floating Particles
          ..._particles.map(
            (particle) => AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final time = _particleController.value + particle.delay;
                final yOffset = (time % 1.0) * -30;
                final opacity = 0.3 + 0.5 * (1 - (time % 1.0));
                final scale = 1.0 + 0.5 * (1 - (time % 1.0));

                return Positioned(
                  left: MediaQuery.of(context).size.width * particle.x / 100,
                  top:
                      MediaQuery.of(context).size.height * particle.y / 100 +
                      yOffset,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 2,
                        height: 2,
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // Profile Header + Stats Block
                    _animatedWithFade(
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: panelBg,
                          border: Border.all(color: panelBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.5),
                                      blurRadius: 24,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: 112,
                                  height: 112,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF3B82F6),
                                        Color(0xFF8B5CF6),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'AS',
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Text(
                              "Abram Anwer",
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "abram.anwer@university.edu",
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatsCard(
                                    icon: Icons.school,
                                    title: 'GPA',
                                    value: '3.7',
                                    cardColor: subtlePanelBg,
                                    borderColor: subtlePanelBorder,
                                    iconBgColor: primaryBlue.withOpacity(0.16),
                                    iconColor: primaryBlue,
                                    titleColor: textSecondary,
                                    valueColor: textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatsCard(
                                    icon: Icons.quiz,
                                    title: 'Quizzes',
                                    value: '24',
                                    cardColor: subtlePanelBg,
                                    borderColor: subtlePanelBorder,
                                    iconBgColor: primaryBlue.withOpacity(0.16),
                                    iconColor: primaryBlue,
                                    titleColor: textSecondary,
                                    valueColor: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      0,
                    ),

                    const SizedBox(height: 32),

                    // Account Section
                    _animatedWithFade(
                      _GlassmorphismSection(
                        title: 'Account',
                        titleColor: textPrimary,
                        itemBgColor: subtlePanelBg,
                        itemBorderColor: subtlePanelBorder,
                        iconBgColor: primaryBlue.withOpacity(0.16),
                        iconColor: primaryBlue,
                        textColor: textPrimary,
                        secondaryTextColor: textSecondary,
                        chevronColor: textSecondary,
                        items: [
                          _MenuItem(
                            icon: Icons.person,
                            label: 'Edit Profile',
                            bgColor: subtlePanelBg,
                            borderColor: subtlePanelBorder,
                            iconBgColor: primaryBlue.withOpacity(0.16),
                            iconColor: primaryBlue,
                            textColor: textPrimary,
                            chevronColor: textSecondary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen(),
                                ),
                              );
                            },
                          ),
                          _MenuItem(
                            icon: Icons.book,
                            label: 'Academic information',
                            bgColor: subtlePanelBg,
                            borderColor: subtlePanelBorder,
                            iconBgColor: primaryBlue.withOpacity(0.16),
                            iconColor: primaryBlue,
                            textColor: textPrimary,
                            chevronColor: textSecondary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AcademicScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      200,
                    ),

                    const SizedBox(height: 24),

                    // Preferences Section
                    _animatedWithFade(
                      _GlassmorphismSection(
                        title: 'Preferences',
                        titleColor: textPrimary,
                        itemBgColor: subtlePanelBg,
                        itemBorderColor: subtlePanelBorder,
                        iconBgColor: primaryBlue.withOpacity(0.16),
                        iconColor: primaryBlue,
                        textColor: textPrimary,
                        secondaryTextColor: textSecondary,
                        chevronColor: textSecondary,
                        items: [
                          _MenuItem(
                            icon: Icons.notifications,
                            label: 'Notifications',
                            bgColor: subtlePanelBg,
                            borderColor: subtlePanelBorder,
                            iconBgColor: primaryBlue.withOpacity(0.16),
                            iconColor: primaryBlue,
                            textColor: textPrimary,
                            chevronColor: textSecondary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen(),
                                ),
                              );
                            },
                          ),
                          _MenuItem(
                            icon: Icons.dark_mode,
                            label: 'Appearance',
                            hasToggle: true,
                            isToggled: isDark,
                            bgColor: subtlePanelBg,
                            borderColor: subtlePanelBorder,
                            iconBgColor: primaryBlue.withOpacity(0.16),
                            iconColor: primaryBlue,
                            textColor: textPrimary,
                            chevronColor: textSecondary,
                            onToggle: () {
                              final newMode = isDark
                                  ? ThemeMode.light
                                  : ThemeMode.dark;
                              themeModeNotifier.value = newMode;
                            },
                          ),
                          _MenuItem(
                            icon: Icons.language,
                            label: 'Language',
                            subtitle: _selectedLanguage,
                            bgColor: subtlePanelBg,
                            borderColor: subtlePanelBorder,
                            iconBgColor: primaryBlue.withOpacity(0.16),
                            iconColor: primaryBlue,
                            textColor: textPrimary,
                            secondaryTextColor: textSecondary,
                            chevronColor: textSecondary,
                            onTap: _showLanguageDialog,
                          ),
                        ],
                      ),
                      400,
                    ),

                    const SizedBox(height: 24),

                    // Support Section
                    _animatedWithFade(
                      _GlassmorphismSection(
                        title: 'Support',
                        titleColor: textPrimary,
                        itemBgColor: subtlePanelBg,
                        itemBorderColor: subtlePanelBorder,
                        iconBgColor: primaryBlue.withOpacity(0.16),
                        iconColor: primaryBlue,
                        textColor: textPrimary,
                        secondaryTextColor: textSecondary,
                        chevronColor: textSecondary,
                        items: [
                          _MenuItem(
                            icon: Icons.info,
                            label: 'about app',
                            bgColor: subtlePanelBg,
                            borderColor: subtlePanelBorder,
                            iconBgColor: primaryBlue.withOpacity(0.16),
                            iconColor: primaryBlue,
                            textColor: textPrimary,
                            chevronColor: textSecondary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AppInfoScreen(),
                                ),
                              );
                            },
                          ),
                          _MenuItem(
                            icon: Icons.help,
                            label: 'help',
                            bgColor: subtlePanelBg,
                            borderColor: subtlePanelBorder,
                            iconBgColor: primaryBlue.withOpacity(0.16),
                            iconColor: primaryBlue,
                            textColor: textPrimary,
                            chevronColor: textSecondary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      600,
                    ),

                    const SizedBox(height: 32),

                    // Log Out Button
                    _animatedWithFade(
                      MouseRegion(
                        onEnter: (_) => setState(() => _isHoverLogout = true),
                        onExit: (_) => setState(() => _isHoverLogout = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.identity()
                            ..scale(_isHoverLogout ? 1.02 : 1.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: _isHoverLogout
                                ? [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : const Color(0xFFFFF1F2),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : const Color(0xFFFECACA),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: const Color(0xFFDC2626),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Log Out",
                                        style: TextStyle(
                                          color: const Color(0xFFDC2626),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      800,
                    ),

                    const SizedBox(height: 24),

                    const Center(
                      child: Text(
                        "Smart Study AI v1.0.0",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Particle {
  final int id;
  final double x;
  final double y;
  final double delay;
  final double duration;

  Particle({
    required this.id,
    required this.x,
    required this.y,
    required this.delay,
    required this.duration,
  });
}

class _StatsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color cardColor;
  final Color borderColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color titleColor;
  final Color valueColor;

  const _StatsCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.cardColor,
    required this.borderColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.titleColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: cardColor,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: iconBgColor,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: titleColor, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassmorphismSection extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color itemBgColor;
  final Color itemBorderColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color textColor;
  final Color? secondaryTextColor;
  final Color chevronColor;
  final List<_MenuItem> items;

  const _GlassmorphismSection({
    required this.title,
    required this.titleColor,
    required this.itemBgColor,
    required this.itemBorderColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.textColor,
    required this.chevronColor,
    this.secondaryTextColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) =>
              Padding(padding: const EdgeInsets.only(bottom: 12), child: item),
        ),
      ],
    );
  }
}

class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool hasToggle;
  final bool isToggled;
  final Color bgColor;
  final Color borderColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color textColor;
  final Color? secondaryTextColor;
  final Color chevronColor;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.hasToggle = false,
    this.isToggled = false,
    required this.bgColor,
    required this.borderColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.textColor,
    required this.chevronColor,
    this.secondaryTextColor,
    this.onToggle,
    this.onTap,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(_isHovered ? 8.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.bgColor,
          border: Border.all(
            color: _isHovered
                ? widget.iconColor.withOpacity(0.45)
                : widget.borderColor,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.hasToggle ? widget.onToggle : widget.onTap ?? () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: widget.iconBgColor,
                    ),
                    child: Icon(widget.icon, color: widget.iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 16,
                          ),
                        ),
                        if (widget.subtitle != null)
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              color:
                                  widget.secondaryTextColor ??
                                  widget.textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.hasToggle)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: 56,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: widget.isToggled
                            ? widget.iconColor
                            : widget.borderColor,
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            left: widget.isToggled ? 28 : 2,
                            top: 2,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right,
                      color: _isHovered
                          ? widget.iconColor
                          : widget.chevronColor,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String language;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? const Color(0xFF3B82F6).withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  language,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
