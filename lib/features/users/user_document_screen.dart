// lib/features/users/presentation/user_documents_screen.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/features/users/model/user_document_model.dart';
import 'package:ipsum_user/features/users/model/user_model.dart';

import 'package:ipsum_user/injection_container.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // 👈 add this
import 'package:url_launcher/url_launcher.dart';

class UserDocumentsScreen extends StatefulWidget {
  final UserModel user;

  const UserDocumentsScreen({super.key, required this.user});

  @override
  State<UserDocumentsScreen> createState() => _UserDocumentsScreenState();
}

class _UserDocumentsScreenState extends State<UserDocumentsScreen> {
  bool _loading = true;
  String? _error;
  List<UserDocumentModel> _docs = [];

  @override
  void initState() {
    super.initState();
    _fetchDocs();
  }

  Future<void> _fetchDocs() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final repo = sl<UsersRepository>();
      final data = await repo.getUserDocuments(widget.user.id!);
      if (!mounted) return;
      setState(() {
        _docs = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = (widget.user.fullName ?? widget.user.username).trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: TitleWidget(label: '$name Documents'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchDocs,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ListView(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    }

    if (_docs.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 40),
          Center(child: Text('No documents found for this user')),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _docs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final d = _docs[index];
        return _buildDocTile(context, d);
      },
    );
  }

  Widget _buildDocTile(BuildContext context, UserDocumentModel d) {
    final isPdf = d.fileName.toLowerCase().endsWith('.pdf');
    final docType = isPdf ? 'PDF' : 'FILE';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      // inside _buildDocTile onTap:
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserDocumentDetailScreen(
              document: d,
              user: widget.user, // 👈 pass user id
            ),
          ),
        );

        if (updated is UserDocumentModel) {
          setState(() {
            final idx = _docs.indexWhere((x) => x.id == updated.id);
            if (idx != -1) _docs[idx] = updated;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.withOpacity(0.14),
            width: 0.7,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: isPdf ? Colors.redAccent : AppColors.primary,
              child: Icon(
                isPdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File name + type chip
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          d.fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPdf
                              ? Colors.redAccent.withOpacity(0.08)
                              : AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          docType,
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: isPdf ? Colors.redAccent : AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (d.documentNumber.isNotEmpty)
                    Text(
                      'Doc No: ${d.documentNumber}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textGrey,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    'Issue: ${d.issueDate}   •   Expiry: ${d.expiryDate}',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class UserDocumentDetailScreen extends StatefulWidget {
  final UserDocumentModel document;
  final UserModel user;

  const UserDocumentDetailScreen({
    super.key,
    required this.document,
    required this.user,
  });

  @override
  State<UserDocumentDetailScreen> createState() =>
      _UserDocumentDetailScreenState();
}

class _UserDocumentDetailScreenState extends State<UserDocumentDetailScreen> {
  late TextEditingController _fileNameController;
  late TextEditingController _docNumberController;
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;

  bool _saving = false;
  String? _pickedFilePath;
  String? _pickedFileName;

  @override
  void initState() {
    super.initState();
    _fileNameController = TextEditingController(text: widget.document.fileName);
    _docNumberController =
        TextEditingController(text: widget.document.documentNumber);
    _issueDateController =
        TextEditingController(text: widget.document.issueDate);
    _expiryDateController =
        TextEditingController(text: widget.document.expiryDate);
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    _docNumberController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpg',
        'jpeg',
        'png',
        'webp',
        'doc',
        'docx',
      ],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedFilePath = result.files.single.path!;
        _pickedFileName = result.files.single.name;
        _fileNameController.text = _pickedFileName ?? _fileNameController.text;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_pickedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a file to upload'),
        ),
      );
      return;
    }

    final repo = sl<UsersRepository>();

    setState(() => _saving = true);

    try {
      final updated = await repo.updateUserDocument(
        userId: widget.user.id!,
        documentId: widget.document.id,
        filePath: _pickedFilePath!,
        fileName: _fileNameController.text.trim(),
        documentNumber: _docNumberController.text.trim(),
        issueDate: _issueDateController.text.trim(),
        expiryDate: _expiryDateController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document updated successfully')),
      );

      Navigator.pop(context, updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
      setState(() => _saving = false);
    }
  }

  bool get _isPdf =>
      widget.document.fileName.toLowerCase().endsWith('.pdf');

  @override
  Widget build(BuildContext context) {
    final String link = widget.document.documentUrl;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Document Details',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saving ? null : _saveChanges,
            icon: _saving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(
              'Save',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ───────── Header card: icon + name + meta ─────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x15000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor:
                        _isPdf ? Colors.redAccent : AppColors.primary,
                    child: Icon(
                      _isPdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // file name + type chip
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _pickedFileName ?? widget.document.fileName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (_isPdf
                                        ? Colors.redAccent
                                        : AppColors.primary)
                                    .withOpacity(0.08),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                _isPdf ? 'PDF' : 'FILE',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: _isPdf
                                      ? Colors.redAccent
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (widget.document.documentNumber.isNotEmpty)
                          Text(
                            'Doc No: ${widget.document.documentNumber}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textGrey,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          'Issue: ${widget.document.issueDate}   •   Expiry: ${widget.document.expiryDate}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ───────── Upload + fields card ─────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x15000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select file row
                  Text(
                    'Upload new file',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _pickedFileName ??
                              'Currently: ${widget.document.fileName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.attach_file, size: 16),
                        label: const Text(
                          'Select file',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  const SizedBox(height: 8),

                  Text(
                    'Details',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // File name
                  TextField(
                    controller: _fileNameController,
                    decoration: InputDecoration(
                      labelText: 'File name',
                      labelStyle: GoogleFonts.poppins(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Document number
                  TextField(
                    controller: _docNumberController,
                    decoration: InputDecoration(
                      labelText: 'Document number',
                      labelStyle: GoogleFonts.poppins(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dates in a row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _issueDateController,
                          decoration: InputDecoration(
                            labelText: 'Issue date (YYYY-MM-DD)',
                            labelStyle: GoogleFonts.poppins(fontSize: 11),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _expiryDateController,
                          decoration: InputDecoration(
                            labelText: 'Expiry date (YYYY-MM-DD)',
                            labelStyle: GoogleFonts.poppins(fontSize: 11),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ───────── Preview card ─────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x15000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview / Open',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.document.documentUrl,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => FullDocView(url: link),
                        //   ),
                        // );
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open Document'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}