import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ai_study_app/screens/ai_chat.dart';

final InAppLocalhostServer _localhostServer = InAppLocalhostServer(port: 8080);

class PuterAiService {
  static Future<String> sendChatMessage({
    required BuildContext context,
    required String message,
    String? pdfContext,
    List<Message>? history,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln('You are an AI study assistant. Be helpful, clear, and concise.');
    if (pdfContext != null) {
      buffer.writeln('\nThe user is studying this document:');
      buffer.writeln(pdfContext);
      buffer.writeln('\nAnswer questions based on this content when relevant.');
    }
    buffer.writeln('\nConversation:');
    if (history != null) {
      for (final msg in history) {
        buffer.writeln('${msg.isAI ? "AI" : "User"}: ${msg.text}');
      }
    }
    buffer.writeln('User: $message');
    buffer.writeln('AI:');

    return runPrompt(
      context: context,
      text: buffer.toString(),
      type: 'chat',
    );
  }

  static Future<void> startServer() async {
    await _localhostServer.start();
  }

  Future<Map<String, dynamic>?> pickAndUploadPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return null;
    final sizeInKB = (bytes.lengthInBytes / 1024).toStringAsFixed(1);
    return {
      'fileName': file.name,
      'fileSize': '$sizeInKB KB',
      'bytes': bytes,
    };
  }

  static Future<String> runPrompt({
    required BuildContext context,
    required String text,
    required String type,
  }) async {
    final completer = Completer<String>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            width: 1,
            height: 1,
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri('http://localhost:8080/assets/puter.html'),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                javaScriptCanOpenWindowsAutomatically: true,
                supportMultipleWindows: true,
              ),
              onCreateWindow: (controller, createWindowAction) async {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: SizedBox(
                      width: double.maxFinite,
                      height: 500,
                      child: InAppWebView(
                        windowId: createWindowAction.windowId,
                        initialSettings: InAppWebViewSettings(
                          javaScriptEnabled: true,
                        ),
                      ),
                    ),
                  ),
                );
                return true;
              },
              onLoadStop: (controller, url) async {
                final urlStr = url.toString();
                if (!urlStr.contains('puter.html')) return;

                controller.removeJavaScriptHandler(handlerName: 'onResult');
                controller.addJavaScriptHandler(
                  handlerName: 'onResult',
                  callback: (args) {
                    String result;
                    if (args[0] is String) {
                      result = args[0] as String;
                    } else {
                      result = jsonEncode(args[0]);
                    }
                    Navigator.of(context).pop();
                    completer.complete(result);
                  },
                );

                await Future.delayed(const Duration(milliseconds: 800));
                final safeText = text
                    .replaceAll('\\', '\\\\')
                    .replaceAll('`', "'")
                    .replaceAll('\$', '');
                controller.evaluateJavascript(
                  source: 'runAI(`$safeText`, "$type");',
                );
              },
            ),
          ),
        );
      },
    );

    return completer.future;
  }
}