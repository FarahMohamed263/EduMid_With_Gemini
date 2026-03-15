import 'package:ai_study_app/screens/home_screen.dart';
import 'package:ai_study_app/screens/login_screen.dart';
import 'package:ai_study_app/screens/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart'; // FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SharedPreferences للتحقق إذا المستخدم شاف الـ Onboarding قبل كده
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    // التحقق إذا المستخدم عامل login قبل كده
    User? currentUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Study App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      /// أول شاشة تظهر:
      home: seenOnboarding
          ? (currentUser != null ? const HomePage() : const LoginScreen())
          : const OnboardingScreen(),

      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        );
      },
    );
  }
}

