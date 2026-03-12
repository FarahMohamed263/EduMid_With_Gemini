import 'package:flutter/material.dart';

class SummarizerPage extends StatefulWidget {
  const SummarizerPage({super.key});

  @override
  State<SummarizerPage> createState() => _SummarizerPageState();
}

class _SummarizerPageState extends State<SummarizerPage> {

  bool uploaded = false;

  void handleUpload() {
    setState(() {
      uploaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "Quiz"),
      //     BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
      //   ],
      // ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Container(
               width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.purple,
                    Colors.teal
                  ],
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// BACK BUTTON
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, "/home");
                    },
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "AI Summarizer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Upload your PDF and get instant summaries",
                    style: TextStyle(color: Colors.white70),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: uploaded ? buildSummarySection() : buildUploadSection(),
            )
          ],
        ),
      ),
    );
  }

  /// =========================
  /// UPLOAD SECTION
  /// =========================

  Widget buildUploadSection() {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      elevation: 6,

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [

            const Icon(Icons.upload_file, size: 60, color: Colors.blue),

            const SizedBox(height: 20),

            const Text(
              "Upload Your Study Material",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Drag and drop or click to upload PDF files",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// UPLOAD BUTTON
            GestureDetector(
              onTap: handleUpload,

              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 40),

                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  children: const [

                    Icon(Icons.picture_as_pdf,
                        size: 60, color: Colors.blue),

                    SizedBox(height: 10),

                    Text(
                      "Click to upload PDF",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Max file size: 10MB",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text("Supports PDF, DOC, DOCX formats"),
            ),

            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text("AI-powered key point extraction"),
            ),

            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text("Instant summary generation"),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// SUMMARY SECTION
  /// =========================

  Widget buildSummarySection() {

    return Column(
      children: [

        /// FILE INFO
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Colors.green),
            title: const Text("Data_Structures_Chapter_3.pdf"),
            subtitle: const Text("2.4 MB • Uploaded successfully"),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        ),

        const SizedBox(height: 20),

        /// SUMMARY
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [

                Text(
                  "AI Summary",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 15),

                Text("Key Concepts",
                    style: TextStyle(fontWeight: FontWeight.bold)),

                SizedBox(height: 5),

                Text(
                    "• Binary Trees: hierarchical structure with two children"),

                Text(
                    "• Traversal Methods: In-order, Pre-order, Post-order"),

                Text(
                    "• Time Complexity: O(log n) balanced trees"),

                SizedBox(height: 15),

                Text("Important Definitions",
                    style: TextStyle(fontWeight: FontWeight.bold)),

                Text(
                    "Balanced Tree: height difference ≤ 1"),

                Text(
                    "Leaf Node: node without children"),

                SizedBox(height: 15),

                Text("Practice Questions",
                    style: TextStyle(fontWeight: FontWeight.bold)),

                Text(
                    "• What is the maximum nodes at level k in binary tree?"),

                Text(
                    "• Difference between complete and full binary tree"),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// ACTION BUTTONS
        Row(
          children: [

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/quiz");
                },
                child: const Text("Generate Quiz"),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    uploaded = false;
                  });
                },
                child: const Text("Upload New"),
              ),
            ),
          ],
        )
      ],
    );
  }
}