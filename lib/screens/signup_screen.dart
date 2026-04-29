import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_study_app/app_palette.dart';

class SignUpScreenNew extends StatefulWidget {
  const SignUpScreenNew({super.key});
  @override
  State<SignUpScreenNew> createState() => _SignUpScreenNewState();
}

class _SignUpScreenNewState extends State<SignUpScreenNew>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  /// ✨ Glow Animation
  late AnimationController glowController;
  late Animation<double> glowAnimation;

  @override
  void initState() {
    super.initState();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(
      begin: 0.2,
      end: 1,
    ).animate(CurvedAnimation(parent: glowController, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Scaffold(
      body: Stack(
        children: [
          /// 🔥 BACKGROUND
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [palette.bgTop, palette.bgBottom],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// 💎 CONTENT
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Text(
                    "AI Study",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Start Your Learning Journey",
                    style: TextStyle(color: palette.textSecondary),
                  ),

                  const SizedBox(height: 40),

                  /// ✨✨ الكارد بالوميض ✨✨
                  AnimatedBuilder(
                    animation: glowAnimation,
                    builder: (context, child) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(24),

                          /// 🔥 glow
                          boxShadow: [
                            BoxShadow(
                              color: palette.primary.withOpacity(
                                0.4 * glowAnimation.value,
                              ),
                              blurRadius: 25 * glowAnimation.value,
                              spreadRadius: 2,
                            ),
                          ],

                          /// 🔥 border glow
                          border: Border.all(
                            color: palette.primary.withOpacity(
                              0.3 * glowAnimation.value,
                            ),
                          ),
                        ),
                        child: child,
                      );
                    },

                    /// 👇 محتوى الكارد
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomInput(
                            icon: Icons.person,
                            hint: "Full Name",
                            controller: nameController,
                          ),

                          const SizedBox(height: 20),

                          CustomInput(
                            icon: Icons.email,
                            hint: "Email",
                            controller: emailController,
                          ),

                          const SizedBox(height: 20),

                          CustomInput(
                            icon: Icons.lock,
                            hint: "Password",
                            controller: passwordController,
                            obscure: !showPassword,
                            suffix: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: palette.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          CustomInput(
                            icon: Icons.lock,
                            hint: "Confirm Password",
                            controller: confirmPasswordController,
                            obscure: !showConfirmPassword,
                            suffix: IconButton(
                              icon: Icon(
                                showConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: palette.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: palette.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final credential = await FirebaseAuth
                                        .instance
                                        .createUserWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password: passwordController.text
                                              .trim(),
                                        );

                                    final user = credential.user;

                                    /// إرسال إيميل التحقق
                                    await user!.sendEmailVerification();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Verification email sent! Check your inbox",
                                        ),
                                      ),
                                    );

                                    /// التحويل لشاشة التفعيل
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/verify-email',
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                "Create Account",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(color: palette.textSecondary),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(color: palette.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "By continuing, you agree to Terms & Privacy",
                    style: TextStyle(color: palette.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingParticles extends StatelessWidget {
  const FloatingParticles({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Stack(
      children: List.generate(30, (index) {
        return Positioned(
          left: (index * 13.0) % MediaQuery.of(context).size.width,
          top: (index * 29.0) % MediaQuery.of(context).size.height,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 20.0),
            duration: Duration(seconds: 3 + index % 5),
            curve: Curves.easeInOut,
            builder: (_, value, __) {
              return Transform.translate(
                offset: Offset(0, -value),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.2, end: 1.0),
                  duration: Duration(seconds: 2 + (index % 3)),
                  curve: Curves.easeInOut,
                  builder: (_, opacityValue, __) {
                    return Opacity(
                      opacity: opacityValue,
                      child: Container(
                        width:
                            4 + (index % 3).toDouble(), // اختلاف بسيط في الحجم
                        height: 4 + (index % 3).toDouble(),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: palette.primary.withOpacity(0.4),
                          boxShadow: [
                            BoxShadow(
                              color: palette.primary.withOpacity(0.6),
                              blurRadius: 8, // 👈 ده ال glow الحقيقي
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final Widget? suffix;

  const CustomInput({
    super.key,
    required this.icon,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
