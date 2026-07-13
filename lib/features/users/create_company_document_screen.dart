import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/injection_container.dart';

class CreateCompanyDocumentScreen extends StatefulWidget {
  const CreateCompanyDocumentScreen({super.key});

  @override
  State<CreateCompanyDocumentScreen> createState() =>
      _CreateCompanyDocumentScreenState();
}

class _CreateCompanyDocumentScreenState
    extends State<CreateCompanyDocumentScreen> {
      
  final _fileNameController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _issueDateController = TextEditingController();
  final _expiryDateController = TextEditingController();

  bool _saving = false;
  String? _pickedFileExtension;
  String? _pickedFilePath;
  String? _pickedFileName;

  @override
  void dispose() {
    _fileNameController.dispose();
    _docNumberController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = _formatDate(picked);
    }
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
    final pickedName = result.files.single.name;
    final extension = pickedName.contains('.')
        ? pickedName.substring(pickedName.lastIndexOf('.'))
        : '';

    setState(() {
      _pickedFilePath = result.files.single.path!;
      _pickedFileName = pickedName;
      _pickedFileExtension = extension;

      // Show full file name initially
      _fileNameController.text = pickedName;
    });
  }
}
String _finalFileName() {
  final typedName = _fileNameController.text.trim();

  if (typedName.isEmpty) return _pickedFileName ?? '';

  if (_pickedFileExtension == null || _pickedFileExtension!.isEmpty) {
    return typedName;
  }

  if (typedName.toLowerCase().endsWith(_pickedFileExtension!.toLowerCase())) {
    return typedName;
  }

  return '$typedName$_pickedFileExtension';
}

  Future<void> _createDocument() async {
    if (_pickedFilePath == null) {
      _showSnack('Please select a document file');
      return;
    }

    if (_fileNameController.text.trim().isEmpty) {
      _showSnack('Please enter file name');
      return;
    }

    if (_issueDateController.text.trim().isEmpty ||
        _expiryDateController.text.trim().isEmpty) {
      _showSnack('Please select issue and expiry dates');
      return;
    }

    setState(() => _saving = true);

    try {
      final created = await sl<UsersRepository>().createCompanyDocument(
        filePath: _pickedFilePath!,
          fileName: _finalFileName(),
        documentNumber: _docNumberController.text.trim(),
        issueDate: _issueDateController.text.trim(),
        expiryDate: _expiryDateController.text.trim(),
      );

      if (!mounted) return;

      _showSnack('Company document created successfully');
      Navigator.pop(context, created);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showSnack('Failed: $e');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool get _isPdf {
    return (_pickedFileName ?? '').toLowerCase().endsWith('.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final fileColor = _isPdf ? Colors.redAccent : AppColors.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              'New Document',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.82),
                      const Color(0xFF101828),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -30,
                      child: _circle(140),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -35,
                      child: _circle(110),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 26,
                      child: Row(
                        children: [
                          Container(
                            height: 62,
                            width: 62,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.18),
                              ),
                            ),
                            child: const Icon(
                              Icons.note_add_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create company document',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Upload official records with validity details.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.75),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
              child: Column(
                children: [
                  _uploadBox(fileColor),
                  const SizedBox(height: 16),
                  _infoCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }

  Widget _uploadBox(Color color) {
    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: _pickedFilePath == null
                ? const Color(0xFFE3E8F0)
                : color.withOpacity(0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.18),
                    color.withOpacity(0.07),
                  ],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Icon(
                _pickedFilePath == null
                    ? Icons.cloud_upload_rounded
                    : _isPdf
                        ? Icons.picture_as_pdf_rounded
                        : Icons.description_rounded,
                color: color,
                size: 38,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _pickedFileName ?? 'Upload company document',
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'PDF, JPG, PNG, DOC or DOCX supported',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _pickedFilePath == null ? 'Choose File' : 'Change File',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard() {
    return _sectionCard(
      title: 'Document Information',
      icon: Icons.edit_document,
      child: Column(
        children: [
          _inputField(
            controller: _fileNameController,
            label: 'File Name',
            icon: Icons.drive_file_rename_outline,
          ),
          const SizedBox(height: 13),
          _inputField(
            controller: _docNumberController,
            label: 'Document Number',
            icon: Icons.confirmation_number_outlined,
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _dateField(
                  controller: _issueDateController,
                  label: 'Issue Date',
                  icon: Icons.calendar_today_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _dateField(
                  controller: _expiryDateController,
                  label: 'Expiry Date',
                  icon: Icons.event_available_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _saving ? null : _createDocument,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(Icons.check_circle_rounded, color: Colors.white),
            label: Text(
              _saving ? 'Creating...' : 'Create Document',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8ECF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 21),
              const SizedBox(width: 9),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF101828),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 19, color: AppColors.primary),
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
        labelStyle: GoogleFonts.poppins(fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickDate(controller),
      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
        suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
        labelStyle: GoogleFonts.poppins(fontSize: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _circle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
      ),
    );
  }
}