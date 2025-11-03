import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'dart:typed_data';
import 'package:translator/translator.dart';

class BooksReadScreen extends StatefulWidget {
  final String? token;
  const BooksReadScreen({super.key, this.token});

  @override
  State<BooksReadScreen> createState() => _BooksReadScreenState();
}

class _BooksReadScreenState extends State<BooksReadScreen> {
  final GoogleTranslator translator = GoogleTranslator();
  final PdfViewerController _pdfController = PdfViewerController();
  PdfControllerPinch? _pdfxController;
  bool _usePdfx = false; // fallback flag
  bool _loading = true;
  Uint8List? _pdfBytes;

  Future<void> translateWord(String word) async {
    try {
      final translation = await translator.translate(word, to: 'ru');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$word → ${translation.text}',
            style: const TextStyle(fontSize: 16),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка перевода: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    try {
      // Try load bytes via rootBundle (reliable across platforms)
      final ByteData data = await rootBundle.load('assets/books/rich-dad-poor-dad.pdf');
      _pdfBytes = data.buffer.asUint8List();
      // Initialize pdfx fallback controller too (so switching is instant)
      _pdfxController = PdfControllerPinch(
        document: PdfDocument.openData(_pdfBytes!),
      );
      if (mounted) setState(() => _loading = false);
    } catch (e) {
      // If even bytes failed, switch to pdfx using asset open (may give clearer error)
      try {
        _pdfxController = PdfControllerPinch(
          document: await PdfDocument.openAsset('assets/books/rich-dad-poor-dad.pdf'),
        );
        _usePdfx = true;
      } catch (_) {
        // Will surface in UI error view
      }
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _pdfxController?.dispose();
    super.dispose();
  }

  Future<void> showTranslateDialog() async {
    String input = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Перевод слова'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Введите слово для перевода',
          ),
          onChanged: (v) => input = v.trim(),
          onSubmitted: (v) {
            Navigator.pop(context);
            if (v.trim().isNotEmpty) translateWord(v.trim());
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (input.isNotEmpty) translateWord(input);
            },
            child: const Text('Перевести'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Reader'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _usePdfx
              ? _buildPdfxView()
              : _buildSfPdfViewOrFallback(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showTranslateDialog,
        icon: const Icon(Icons.translate_rounded),
        label: const Text('Перевод'),
      ),
    );
  }

  Widget _buildSfPdfViewOrFallback() {
    if (_pdfBytes == null) {
      return _buildErrorView('Не удалось загрузить PDF из assets');
    }
    return SfPdfViewer.memory(
      _pdfBytes!,
      controller: _pdfController,
      onDocumentLoaded: (_) {},
      onDocumentLoadFailed: (details) {
        if (!mounted) return;
        // Switch to pdfx fallback automatically
        setState(() => _usePdfx = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Syncfusion не открыл PDF, пробую другой рендерер...\n${details.error}\n${details.description}',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      },
    );
  }

  Widget _buildPdfxView() {
    final controller = _pdfxController;
    if (controller == null) {
      return _buildErrorView('PDF контроллер не инициализирован');
    }
    return PdfViewPinch(
      controller: controller,
      onDocumentError: (err) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка PDF: $err')),
        );
      },
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _usePdfx = false;
                });
                _preparePdf();
              },
              child: const Text('Повторить'),
            )
          ],
        ),
      ),
    );
  }
}
