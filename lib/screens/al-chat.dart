import 'dart:async';
import 'package:ai_study_app/screens/pdf_page.dart';
import 'package:flutter/material.dart';
import 'package:ai_study_app/screens/main_navigation.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: Stack(
        children: [
          /// Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B0F2A), Color(0xFF050816)],
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
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),

                          /// 📄 PDF Button
                          GestureDetector(
                            onTap: goToPDF,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.description,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: const [
                          Icon(Icons.auto_awesome, color: Colors.blue),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AI Study Chat",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Always here to help",
                                style: TextStyle(color: Colors.grey),
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
                            color: msg.isAI ? Colors.white10 : Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.text,
                            style: const TextStyle(color: Colors.white),
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
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white10,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => handleSendMessage(controller.text),
                        child: const Icon(Icons.send, color: Colors.blue),
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
