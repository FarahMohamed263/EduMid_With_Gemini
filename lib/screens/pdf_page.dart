import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ai_study_app/services/pdf_ai_service.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> with TickerProviderStateMixin {
  final PdfAiService _service = PdfAiService();
  final Random random = Random();

  // States
  bool _isLoading = false;
  String _loadingMessage = '';
  String? _pdfName;
  String? _pdfSize;
  String? _summary;
  List<QuizQuestion>? _quiz;
  bool _showQuiz = false;

  // Animations
  late final AnimationController _orbController;
  late final AnimationController _pulseController;
  late final Animation<double> _orbAnimationY;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _orbController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _orbAnimationY = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.easeInOut),
    );
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _orbController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    setState(() {
      _isLoading = true;
      _loadingMessage = '📤 جاري رفع الملف...';
      _summary = null;
      _quiz = null;
      _pdfName = null;
      _showQuiz = false;
    });

    try {
      final result = await _service.pickAndUploadPdf();

      if (result == null) {
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _pdfName = result['fileName'];
        _pdfSize = result['fileSize'];
        _loadingMessage = '🤖 جاري إنشاء الملخص...';
      });

      final summary = await _service.generateSummary(result['text']);

      setState(() {
        _summary = summary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleGenerateQuiz() async {
    if (_summary == null) return;
    setState(() {
      _isLoading = true;
      _loadingMessage = '📝 جاري إنشاء الأسئلة...';
    });
    try {
      final quiz = await _service.generateQuiz(_summary!);
      setState(() {
        _quiz = quiz;
        _showQuiz = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _floatingParticles() {
    return Stack(
      children: List.generate(20, (i) => Positioned(
        left: random.nextDouble() * MediaQuery.of(context).size.width,
        top: random.nextDouble() * MediaQuery.of(context).size.height,
        child: Container(
          width: 4, height: 4,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F2A),
      body: Stack(
        children: [
          _floatingParticles(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 10,
                            )],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("AI Summarizer",
                                style: TextStyle(color: Colors.white, fontSize: 22)),
                            Text("Upload your PDF and get instant summaries",
                                style: TextStyle(color: Colors.blueAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Body
                  Expanded(
                    child: _isLoading
                        ? _buildLoading()
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: _summary == null
                                ? _uploadScreen()
                                : _showQuiz && _quiz != null
                                    ? _QuizView(
                                        questions: _quiz!,
                                        onUploadNew: () => setState(() {
                                          _summary = null;
                                          _quiz = null;
                                          _showQuiz = false;
                                        }),
                                      )
                                    : _summaryScreen(),
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

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blue),
          const SizedBox(height: 20),
          Text(_loadingMessage,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _uploadScreen() {
    return GestureDetector(
      key: const ValueKey('upload'),
      onTap: _handleUpload,
      child: Container(
        width: double.infinity,
        height: 350,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
          boxShadow: [BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 40, spreadRadius: 5,
          )],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _orbAnimationY,
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _orbAnimationY.value),
                child: const Icon(Icons.file_present, color: Colors.blue, size: 60),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Click to upload PDF",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 6),
            const Text("Max file size: 10MB",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _summaryScreen() {
    return SingleChildScrollView(
      key: const ValueKey('summary'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Card
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.picture_as_pdf,
                        color: Colors.red, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_pdfName ?? 'ملف PDF',
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                        Text(_pdfSize ?? '',
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        const Text("Uploaded successfully",
                            style: TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("📄 الملخص",
                      style: TextStyle(color: Colors.blue, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(_summary!,
                      style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.6)),
                  const SizedBox(height: 20),

                  // Buttons
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _summary = null;
                      _quiz = null;
                      _showQuiz = false;
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Upload New",
                        style: TextStyle(fontSize: 16)),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: _handleGenerateQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Generate Quiz",
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Quiz View
// ─────────────────────────────────────────────
class _QuizView extends StatefulWidget {
  final List<QuizQuestion> questions;
  final VoidCallback onUploadNew;

  const _QuizView({required this.questions, required this.onUploadNew});

  @override
  State<_QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<_QuizView> {
  final Map<int, int> _answers = {};
  bool _submitted = false;

  int get _score => _answers.entries
      .where((e) => e.value == widget.questions[e.key].correctIndex)
      .length;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("🎯 الاختبار",
                style: TextStyle(color: Colors.white, fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            ...widget.questions.asMap().entries.map((entry) {
              final i = entry.key;
              final q = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${i + 1}. ${q.question}',
                        style: const TextStyle(color: Colors.white,
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    ...q.options.asMap().entries.map((opt) {
                      final isSelected = _answers[i] == opt.key;
                      final isCorrect = opt.key == q.correctIndex;

                      Color borderColor = Colors.grey.shade700;
                      Color bgColor = Colors.transparent;

                      if (_submitted) {
                        if (isCorrect) {
                          borderColor = Colors.green;
                          bgColor = Colors.green.withOpacity(0.15);
                        } else if (isSelected) {
                          borderColor = Colors.red;
                          bgColor = Colors.red.withOpacity(0.15);
                        }
                      } else if (isSelected) {
                        borderColor = Colors.blue;
                        bgColor = Colors.blue.withOpacity(0.15);
                      }

                      return GestureDetector(
                        onTap: _submitted
                            ? null
                            : () => setState(() => _answers[i] = opt.key),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(opt.value,
                                  style: const TextStyle(color: Colors.white))),
                              if (_submitted && isCorrect)
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 18),
                              if (_submitted && isSelected && !isCorrect)
                                const Icon(Icons.cancel,
                                    color: Colors.red, size: 18),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),

            const SizedBox(height: 8),

            if (!_submitted)
              ElevatedButton(
                onPressed: _answers.length == widget.questions.length
                    ? () => setState(() => _submitted = true)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  disabledBackgroundColor: Colors.grey.shade800,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("تسليم الإجابات",
                    style: TextStyle(fontSize: 16)),
              ),

            if (_submitted) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  '🏆 نتيجتك: $_score / ${widget.questions.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.green, fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: widget.onUploadNew,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Upload New", style: TextStyle(fontSize: 16)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}