import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_study_app/app_palette.dart';
import '../l10n/app_localizations.dart';
import '../theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool isLoading = false;

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
    ).animate(
      CurvedAnimation(
        parent: glowController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    glowController.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  /// ================= Theme Toggle =================
  void _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    themeModeNotifier.value =
        themeModeNotifier.value == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark;

    prefs.setString(
      'theme',
      themeModeNotifier.value == ThemeMode.dark
          ? 'dark'
          : 'light',
    );
  }

  /// ================= Language Dialog =================
  void _showLanguageDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                localeNotifier.value = const Locale('en');

                prefs.setString('language', 'en');

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                localeNotifier.value = const Locale('ar');

                prefs.setString('language', 'ar');

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ================= Sign Up =================
  Future<void> _signUp() async {
    final localizations = AppLocalizations.of(context)!;

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = credential.user;

      if (user == null) return;

      /// ✅ حفظ الاسم داخل FirebaseAuth
      await user.updateDisplayName(
        nameController.text.trim(),
      );

      /// ✅ تحديث بيانات اليوزر
      await user.reload();

      /// ✅ الحصول على أحدث نسخة من اليوزر
      final updatedUser =
          FirebaseAuth.instance.currentUser;

      /// ✅ حفظ البيانات داخل Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser!.uid)
          .set({
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      /// ✅ إرسال إيميل التحقق
      await updatedUser.sendEmailVerification();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Verification email sent! Check your inbox",
          ),
        ),
      );

      Navigator.pushReplacementNamed(
        context,
        '/verify-email',
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already in use';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  palette.bgTop,
                  palette.bgBottom,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// SETTINGS
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.language,
                    color: palette.textPrimary,
                    size: 28,
                  ),
                  onPressed: () =>
                      _showLanguageDialog(context),
                ),

                const SizedBox(width: 10),

                IconButton(
                  icon: Icon(
                    palette.isDark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: palette.textPrimary,
                    size: 28,
                  ),
                  onPressed: _toggleTheme,
                ),
              ],
            ),
          ),

          /// CONTENT
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Text(
                    localizations.appTitle,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    localizations.startLearningJourney,
                    style: TextStyle(
                      color: palette.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  AnimatedBuilder(
                    animation: glowAnimation,
                    builder: (context, child) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius:
                              BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: palette.primary
                                  .withOpacity(
                                0.4 * glowAnimation.value,
                              ),
                              blurRadius:
                                  25 * glowAnimation.value,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(
                            color: palette.primary
                                .withOpacity(
                              0.3 * glowAnimation.value,
                            ),
                          ),
                        ),
                        child: child,
                      );
                    },

                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomInput(
                            icon: Icons.person,
                            hint: localizations.fullName,
                            controller: nameController,
                          ),

                          const SizedBox(height: 20),

                          CustomInput(
                            icon: Icons.email,
                            hint: localizations.email,
                            controller: emailController,
                          ),

                          const SizedBox(height: 20),

                          CustomInput(
                            icon: Icons.lock,
                            hint: localizations.password,
                            controller:
                                passwordController,
                            obscure: !showPassword,
                            suffix: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color:
                                    palette.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword =
                                      !showPassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          CustomInput(
                            icon: Icons.lock,
                            hint: localizations
                                .confirmPassword,
                            controller:
                                confirmPasswordController,
                            obscure:
                                !showConfirmPassword,
                            suffix: IconButton(
                              icon: Icon(
                                showConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color:
                                    palette.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  showConfirmPassword =
                                      !showConfirmPassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor:
                                    palette.primary,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),
                                ),
                              ),
                              onPressed:
                                  isLoading ? null : _signUp,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child:
                                          CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      localizations
                                          .createAccount,
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                localizations
                                    .alreadyHaveAccount,
                                style: TextStyle(
                                  color: palette
                                      .textSecondary,
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context);
                                },
                                child: Text(
                                  localizations.signIn,
                                  style: TextStyle(
                                    color: palette
                                        .textPrimary,
                                  ),
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
                    localizations.agreeTerms,
                    style: TextStyle(
                      color: palette.textSecondary,
                    ),
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
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
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
