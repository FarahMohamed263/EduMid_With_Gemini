import 'EditProfileScreen .dart';
import 'AcademicInfo.dart';
import 'package:ai_study_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _isHoverLogout = false;
  bool _isDarkMode = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F2A),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0B0F2A), Color(0xFF050816)],
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
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6),
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
                          color: Colors.white.withOpacity(0.04),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
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
                                      color: const Color(
                                        0xFF3B82F6,
                                      ).withOpacity(0.5),
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
                                  child: const Center(
                                    child: Text(
                                      'AS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const Text(
                              "Abram Anwer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "abram.anwer@university.edu",
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
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
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatsCard(
                                    icon: Icons.quiz,
                                    title: 'Quizzes',
                                    value: '24',
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
                        items: [
                          _MenuItem(
                            icon: Icons.person,
                            label: 'Edit Profile',
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
                        items: [
                          const _MenuItem(
                            icon: Icons.notifications,
                            label: 'Notifications',
                          ),
                          _MenuItem(
                            icon: Icons.dark_mode,
                            label: 'Appearance',
                            hasToggle: true,
                            isToggled: _isDarkMode,
                            onToggle: () =>
                                setState(() => _isDarkMode = !_isDarkMode),
                          ),
                          const _MenuItem(
                            icon: Icons.language,
                            label: 'Language',
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
                        items: const [
                          _MenuItem(icon: Icons.info, label: 'about app'),
                          _MenuItem(icon: Icons.help, label: 'help'),
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
                              color: Colors.white.withOpacity(0.05),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
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
                                        color: const Color(0xFFEF4444),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Log Out",
                                        style: TextStyle(
                                          color: const Color(0xFFEF4444),
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

  const _StatsCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF111827).withOpacity(0.85),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF3B82F6).withOpacity(0.18),
            ),
            child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
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
  final List<_MenuItem> items;

  const _GlassmorphismSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
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
  final bool hasToggle;
  final bool isToggled;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.hasToggle = false,
    this.isToggled = false,
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
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(_isHovered ? 8.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF3B82F6).withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
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
                      color: const Color(0xFF3B82F6).withOpacity(0.2),
                    ),
                    child: Icon(
                      widget.icon,
                      color: const Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  if (widget.hasToggle)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 56,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: widget.isToggled
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFF374151),
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
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF9CA3AF),
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
