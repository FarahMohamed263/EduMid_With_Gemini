import 'package:ai_study_app/screens/EmailVerificationScreen.dart';
import 'package:ai_study_app/screens/login_screen.dart';
import 'package:ai_study_app/screens/main_navigation.dart';
import 'package:ai_study_app/screens/onboarding_page.dart';
import 'package:ai_study_app/screens/splash_screen.dart';

import 'package:flutter/material.dart';
import 'theme_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AI Study App',
          theme: appLightTheme,
          darkTheme: appDarkTheme,
          themeMode: mode,

          /// 🔥 هنا التحكم في الفلو كله
          home: const AuthWrapper(),

          routes: {
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const MainNavigation(),
            '/verify-email': (context) =>
                const EmailVerificationScreen(),
          },
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 Auth Wrapper
////////////////////////////////////////////////////////////

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoading = true;
  Widget? screen;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash effect

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      /// ❌ مفيش يوزر
      screen = const LoginScreen();
    } else {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user!.emailVerified) {
        /// ✅ مفعل
        screen = const MainNavigation();
      } else {
        /// ❌ مش مفعل → يروح شاشة التفعيل
        screen = const EmailVerificationScreen();
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SplashScreen();
    } else {
      return screen!;
    }
  }
}