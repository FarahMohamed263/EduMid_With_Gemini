import 'package:flutter/material.dart';

class Message {
  final int id;
  final String text;
  final bool isUser;

  Message({required this.id, required this.text, required this.isUser});
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController controller = TextEditingController();

  List<Message> messages = [
    Message(
      id: 1,
      text:
          "Hello! I'm your AI study assistant. I can help you understand your course material.",
      isUser: false,
    )
  ];

  bool isTyping = false;

  void sendMessage() {

    if (controller.text.trim().isEmpty) return;

    final userMessage = Message(
      id: messages.length + 1,
      text: controller.text,
      isUser: true,
    );

    setState(() {
      messages.add(userMessage);
      isTyping = true;
    });

    controller.clear();

    Future.delayed(const Duration(milliseconds: 1500), () {

      final aiMessage = Message(
        id: messages.length + 1,
        text:
            "Based on your notes about binary trees, I can explain that concept.",
        isUser: false,
      );

      setState(() {
        messages.add(aiMessage);
        isTyping = false;
      });

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      body: Column(
        children: [

          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.purple,
                  Colors.teal,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white),
                    ),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [

                        Text(
                          "AI Study Chat",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "Always here to help",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        )

                      ],
                    )

                  ],
                )

              ],
            ),
          ),

          /// MESSAGES
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {

                if (index >= messages.length) {
                  return typingIndicator();
                }

                final message = messages[index];

                return Align(
                  alignment:
                      message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(16),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(.05),
                        )
                      ],
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );

              },
            ),
          ),

          /// INPUT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.05),
                )
              ],
            ),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.purple,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                )

              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget typingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text("Typing..."),
      ),
    );
  }
}