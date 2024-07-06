import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PDFScreen extends StatefulWidget {
  final String url;

  const PDFScreen({super.key, required this.url});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf(widget.url);
  }

  Future<void> _downloadAndSavePdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/temp.pdf');

      await file.writeAsBytes(bytes, flush: true);
      setState(() {
        localPath = file.path;
      });
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF26B6C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Navigator.pop(context);
            // Handle more button press
          },
        ),
        title: const Center(
            child: Text(
              'PDF reader',
              style: TextStyle(
                  fontFamily: 'PaynetB',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF)),
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFFFFFFFF)),
            onPressed: () {
              // Handle more button press
            },
          ),
        ],
      ),
      body: localPath != null
          ? PDFView(
        filePath: localPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onRender: (pages) {
          setState(() {});
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
