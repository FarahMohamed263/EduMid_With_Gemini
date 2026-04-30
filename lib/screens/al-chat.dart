import 'dart:async';
import 'package:ai_study_app/screens/pdf_page.dart';
import 'package:ai_study_app/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:ai_study_app/screens/main_navigation.dart';
import '../localization_helper.dart';

class Message {
  final String id;
  final String text;
  final bool isAI;

  Message({required this.id, required this.text, required this.isAI});
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [
    Message(
      id: '1',
      text:
          "Hello! I'm your AI study assistant. I can help you understand your course material.",
      isAI: true,
    ),
    Message(
      id: '2',
      text: 'Can you help me understand quantum physics?',
      isAI: false,
    ),
    Message(
      id: '3',
      text:
          "Of course! Quantum physics is a fascinating field. What do you want to explore?",
      isAI: true,
    ),
  ];

  final TextEditingController controller = TextEditingController();

  void handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add(
        Message(id: DateTime.now().toString(), text: text, isAI: false),
      );
    });

    controller.clear();

    Timer(const Duration(seconds: 1), () {
      List<String> responses = [
        "That's a great question! Let me explain...",
        "I can help you with that 👌",
        "Excellent question!",
        "Let me simplify it for you...",
      ];

      setState(() {
        messages.add(
          Message(
            id: DateTime.now().toString(),
            text: responses[DateTime.now().millisecond % responses.length],
            isAI: true,
          ),
        );
      });
    });
  }

  void goBackHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
      (route) => false,
    );
  }

  void goToPDF() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PdfPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Scaffold(
      backgroundColor: palette.bgBottom,
      body: Stack(
        children: [
          /// Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [palette.bgTop, palette.bgBottom],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// Main Content
          SafeArea(
            child: Column(
              children: [
                /// 🔹 Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// 🔙 BACK BUTTON
                          GestureDetector(
                            onTap: goBackHome,
                            child: Icon(
                              Icons.arrow_back,
                              color: palette.textPrimary,
                            ),
                          ),

                          /// 📄 PDF Button
                          GestureDetector(
                            onTap: goToPDF,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: palette.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: palette.border),
                              ),
                              child: Icon(
                                Icons.description,
                                color: palette.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: palette.primary),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AI Study Chat",
                                style: TextStyle(
                                  color: palette.textPrimary,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Always here to help",
                                style: TextStyle(color: palette.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// 💬 CHAT LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];

                      return Align(
                        alignment: msg.isAI
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 250),
                          decoration: BoxDecoration(
                            color: msg.isAI ? palette.surface : palette.primary,
                            borderRadius: BorderRadius.circular(12),
                            border: msg.isAI
                                ? Border.all(color: palette.border)
                                : null,
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isAI
                                  ? palette.textPrimary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// ✏️ INPUT
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: TextStyle(color: palette.textPrimary),
                          decoration: InputDecoration(
                            hintText: CustomLocalizations.of(
                              context,
                            ).get('typeAMessage'),
                            hintStyle: TextStyle(color: palette.textSecondary),
                            filled: true,
                            fillColor: palette.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: palette.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: palette.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: palette.primary,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => handleSendMessage(controller.text),
                        child: Icon(Icons.send, color: palette.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
