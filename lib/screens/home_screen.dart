import 'package:flutter/material.dart';
import '../widgets/image_with_fallback.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Study App"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Welcome to AI Study App",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ImageWithFallback(
              imageUrl: "https://picsum.photos/200",
              width: 200,
              height: 200,
            ),

          ],
        ),
      ),
    );
  }
}