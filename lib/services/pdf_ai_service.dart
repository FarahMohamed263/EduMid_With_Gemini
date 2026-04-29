import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfAiService {
  final GenerativeModel _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash', // ✅ أحدث نسخة
  );

  // 1. اختيار الـ PDF من الجهاز (يشتغل على الويب والموبايل)
  Future<Map<String, dynamic>?> pickAndUploadPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return null;

    // استخدام bytes مباشرة - يعمل على الويب والموبايل
    final bytes = result.files.single.bytes;
    if (bytes == null) return null;

    // حجم الملف
    final fileSizeMB = (bytes.length / (1024 * 1024)).toStringAsFixed(1);

    // قراءة النص
    final text = await _extractTextFromPdfBytes(bytes);

    return {
      'fileName': result.files.single.name,
      'fileSize': '$fileSizeMB MB',
      'text': text,
    };
  }

  // 2. استخراج النص من الـ PDF (من bytes)
  Future<String> _extractTextFromPdfBytes(Uint8List bytes) async {
    final document = PdfDocument(inputBytes: bytes);
    final extractor = PdfTextExtractor(document);
    final text = extractor.extractText();
    document.dispose();
    return text;
  }

  // 3. Summary
  Future<String> generateSummary(String pdfText) async {
    final prompt =
        '''
أنت مساعد تعليمي. لخص النص التالي بشكل واضح ومنظم بنقاط مرتبة.
النص:
$pdfText
''';
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? 'لم يتم إنشاء الملخص';
  }

  // 4. Quiz
  Future<List<QuizQuestion>> generateQuiz(String pdfText) async {
    final prompt =
        '''
بناءً على النص التالي، أنشئ 5 أسئلة اختيار من متعدد.
أرجع JSON فقط بدون أي نص إضافي أو backticks:
[
  {
    "question": "السؤال",
    "options": ["أ", "ب", "ج", "د"],
    "correctIndex": 0
  }
]
النص:
$pdfText
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final jsonStr = response.text ?? '[]';
    final clean = jsonStr
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final List<dynamic> jsonList = jsonDecode(clean);
    return jsonList.map((e) => QuizQuestion.fromJson(e)).toList();
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'],
    );
  }
}
