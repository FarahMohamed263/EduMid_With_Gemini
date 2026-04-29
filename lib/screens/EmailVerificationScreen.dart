import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  final math.Random _random = math.Random();
  final List<_Particle> _particles = [];

  late final AnimationController _pulseController;
  Timer? _verificationTimer;
  Timer? _toastTimer;

  bool _showToast = false;
  bool _canResendEmail = false;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _buildParticles();
    _startFlow();
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _toastTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _buildParticles() {
    for (var i = 0; i < 20; i++) {
      _particles.add(
        _Particle(
          left: _random.nextDouble(),
          top: _random.nextDouble(),
          size: 1.5 + _random.nextDouble() * 2.5,
          opacity: 0.18 + _random.nextDouble() * 0.45,
          duration: 3 + _random.nextDouble() * 2,
          phase: _random.nextDouble() * math.pi * 2,
        ),
      );
    }
  }

  Future<void> _startFlow() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    if (user.emailVerified) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    await _sendVerificationEmail();

    _verificationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkEmailVerified();
    });
  }

  Future<void> _sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      await user.sendEmailVerification();
      if (!mounted) return;

      setState(() {
        _canResendEmail = false;
      });

      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return;

      setState(() {
        _canResendEmail = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _canResendEmail = true;
      });
    }
  }

  Future<void> _checkEmailVerified() async {
    if (_isChecking) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    _isChecking = true;
    try {
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser?.emailVerified ?? false) {
        _verificationTimer?.cancel();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      _isChecking = false;
    }
  }

  Future<void> _logout() async {
    _verificationTimer?.cancel();
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _handleResend() {
    if (!_canResendEmail) {
      return;
    }

    _sendVerificationEmail();

    setState(() {
      _showToast = true;
    });

    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _showToast = false;
      });
    });
  }

  Future<void> _handleVerified() async {
    await _checkEmailVerified();
  }

  Widget _buildParticle(
    _Particle particle,
    double width,
    double height,
    double t,
  ) {
    final oscillation = (t * math.pi * 2 / particle.duration) + particle.phase;
    final offsetY = math.sin(oscillation) * 14;
    final offsetX = math.cos(oscillation) * 4;

    return Positioned(
      left: particle.left * width,
      top: particle.top * height,
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Opacity(
          opacity: particle.opacity,
          child: Container(
            width: particle.size,
            height: particle.size,
            decoration: const BoxDecoration(
              color: Color(0xFF60A5FA),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x3360A5FA),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0B0F2A), Color(0xFF050816)],
                ),
              ),
              child: SizedBox.expand(),
            ),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  final t = _pulseController.value;
                  return Stack(
                    children: [
                      for (final particle in _particles)
                        _buildParticle(particle, size.width, size.height, t),
                    ],
                  );
                },
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _logout,
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFFDCE7FF),
                          size: 20,
                        ),
                        splashRadius: 22,
                      ),
                      const Text(
                        'Verify Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 48),
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, _) {
                                final pulse =
                                    1 + (_pulseController.value * 0.05);
                                return Transform.scale(
                                  scale: pulse,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 126,
                                        height: 126,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0x203B82F6),
                                              Color(0x102B5FD9),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: const Color(0x3348A0FF),
                                            width: 1,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x2648A0FF),
                                              blurRadius: 24,
                                              spreadRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.mail_outline_rounded,
                                            size: 60,
                                            color: Color(0xFF5DA3FF),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 170,
                                        height: 170,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            40,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x164B8EFF),
                                              blurRadius: 44,
                                              spreadRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 36),
                            const Text(
                              'Check Your Email',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 31,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'We sent a verification link to your email. Please open it to continue.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0x99C0D7FF),
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 36),
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4D8DFF),
                                      Color(0xFF5C9BFF),
                                    ],
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x554D8DFF),
                                      blurRadius: 20,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: _handleVerified,
                                    child: const Center(
                                      child: Text(
                                        'I Have Verified',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 42,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0x121F2A52),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0x334D8DFF),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: _canResendEmail
                                        ? _handleResend
                                        : null,
                                    child: Center(
                                      child: Text(
                                        'Resend Email',
                                        style: TextStyle(
                                          color: _canResendEmail
                                              ? const Color(0xFFDCE7FF)
                                              : const Color(0x77C0D7FF),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextButton(
                              onPressed: _logout,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0x77C0D7FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                offset: _showToast ? Offset.zero : const Offset(0, -0.15),
                child: AnimatedOpacity(
                  opacity: _showToast ? 1 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0x334D8DFF), Color(0x33497AE8)],
                            ),
                            border: Border.all(color: const Color(0x554D8DFF)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x55000000),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 8,
                                height: 8,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5DA3FF),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Verification email sent! Check your inbox',
                                style: TextStyle(
                                  color: Color(0xFFDCE7FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.left,
    required this.top,
    required this.size,
    required this.opacity,
    required this.duration,
    required this.phase,
  });

  final double left;
  final double top;
  final double size;
  final double opacity;
  final double duration;
  final double phase;
}
