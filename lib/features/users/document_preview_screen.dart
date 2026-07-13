import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentPreviewScreen extends StatelessWidget {
  final String title;
  final String url;

  const DocumentPreviewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  bool get _isPdf {
    final cleanUrl = url.split('?').first.toLowerCase();
    return cleanUrl.endsWith('.pdf');
  }

  bool get _isImage {
    final cleanUrl = url.split('?').first.toLowerCase();
    return cleanUrl.endsWith('.jpg') ||
        cleanUrl.endsWith('.jpeg') ||
        cleanUrl.endsWith('.png') ||
        cleanUrl.endsWith('.webp');
  }

  Future<void> _openExternally(BuildContext context) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open document')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          title.isEmpty ? 'Document Preview' : title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF101828),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _openExternally(context),
            icon: const Icon(Icons.open_in_new_rounded),
          ),
        ],
      ),
      body: _buildPreview(),
    );
  }

  Widget _buildPreview() {
    if (_isPdf) {
      return SfPdfViewer.network(url);
    }

    if (_isImage) {
      return PhotoView(
        imageProvider: NetworkImage(url),
        backgroundDecoration: const BoxDecoration(
          color: Color(0xFFF4F6FA),
        ),
        loadingBuilder: (_, __) {
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) {
          return _unsupportedView();
        },
      );
    }

    return _unsupportedView();
  }

  Widget _unsupportedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Preview is available only for PDF and image files.\nUse the open button to view this file.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}