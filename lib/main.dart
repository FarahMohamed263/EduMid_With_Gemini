import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_page.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Study App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      /// أول شاشة تظهر
      home: const SplashScreen(),

      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const MainNavigation(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        );
      },
    );
  }
}
