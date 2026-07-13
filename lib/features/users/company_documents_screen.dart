import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/users/create_company_document_screen.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/features/users/document_preview_screen.dart';
import 'package:ipsum_user/features/users/model/company_document_model.dart';
import 'package:ipsum_user/injection_container.dart';
import 'package:share_plus/share_plus.dart';

class CompanyDocumentsScreen extends StatefulWidget {
  const CompanyDocumentsScreen({super.key});

  @override
  State<CompanyDocumentsScreen> createState() => _CompanyDocumentsScreenState();
}

class _CompanyDocumentsScreenState extends State<CompanyDocumentsScreen> {
  bool _loading = true;
  String? _error;
  List<CompanyDocumentModel> _docs = [];

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
      final data = await sl<UsersRepository>().getCompanyDocuments();
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

  Widget _documentCardWithDelete(CompanyDocumentModel doc) {
    return Dismissible(
      key: ValueKey(doc.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (_) => _confirmDelete(doc),
      onDismissed: (_) {
        setState(() {
          _docs.removeWhere((e) => e.id == doc.id);
        });
      },
      child: _documentCard(doc),
    );
  }

  Future<bool> _confirmDelete(CompanyDocumentModel doc) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Delete Document?',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  doc.fileName.isEmpty
                      ? 'This document will be permanently deleted.'
                      : doc.fileName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.red.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 52),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF101828),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(0, 52),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != true) return false;

    try {
      await sl<UsersRepository>().deleteCompanyDocument(doc.id);

      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text('Document deleted successfully'),
        ),
      );

      return true;
    } catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text('Failed: $e'),
        ),
      );

      return false;
    }
  }

  Future<void> _openCreateScreen() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateCompanyDocumentScreen(),
      ),
    );

    if (created is CompanyDocumentModel) {
      setState(() => _docs.insert(0, created));
    } else {
      _fetchDocs();
    }
  }

  Future<void> _openDetail(CompanyDocumentModel doc) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompanyDocumentDetailScreen(document: doc),
      ),
    );

    if (result == true) {
      _fetchDocs();
    } else if (result is CompanyDocumentModel) {
      final index = _docs.indexWhere((x) => x.id == result.id);

      if (index != -1) {
        setState(() {
          _docs[index] = result;
        });
      }
    }
  }

  int get _expiredCount {
    return _docs.where((doc) {
      try {
        if (doc.expiryDate.isEmpty) return false;
        return DateTime.parse(doc.expiryDate).isBefore(DateTime.now());
      } catch (_) {
        return false;
      }
    }).length;
  }

  int get _pdfCount {
    return _docs.where((e) => e.fileName.toLowerCase().endsWith('.pdf')).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateScreen,
        elevation: 8,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'New Document',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDocs,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _premiumAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 90),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _premiumAppBar() {
    return SliverAppBar(
      expandedHeight: 215,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        'Company Documents',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Colors.white,
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
                right: -45,
                top: -20,
                child: _glowCircle(145),
              ),
              Positioned(
                left: -35,
                bottom: -35,
                child: _glowCircle(110),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 24,
                child: Row(
                  children: [
                    Container(
                      height: 62,
                      width: 62,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.20),
                        ),
                      ),
                      child: const Icon(
                        Icons.business_center_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manage company files',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Licenses, certificates, approvals and official records',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.76),
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
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 90),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return _errorState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statsRow(),
        const SizedBox(height: 18),
        _sectionHeader(),
        const SizedBox(height: 12),
        if (_docs.isEmpty)
          _emptyState()
        else
          ..._docs.map(_documentCardWithDelete),
      ],
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            title: 'Total',
            value: '${_docs.length}',
            icon: Icons.folder_copy_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            title: 'PDF Files',
            value: '$_pdfCount',
            icon: Icons.picture_as_pdf_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            title: 'Expired',
            value: '$_expiredCount',
            icon: Icons.warning_amber_rounded,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF101828),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Uploaded Documents',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF101828),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            '${_docs.length} files',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _documentCard(CompanyDocumentModel doc) {
    final isPdf = doc.fileName.toLowerCase().endsWith('.pdf');
    final expired = _isExpired(doc.expiryDate);
    final color = expired
        ? Colors.orange
        : isPdf
            ? Colors.redAccent
            : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openDetail(doc),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE7EBF2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.045),
                  blurRadius: 20,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.18),
                        color.withOpacity(0.07),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    isPdf
                        ? Icons.picture_as_pdf_rounded
                        : Icons.description_rounded,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.fileName.isEmpty
                            ? 'Untitled Document'
                            : doc.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _chip(isPdf ? 'PDF' : 'FILE', color),
                          if (expired) ...[
                            const SizedBox(width: 6),
                            _chip('EXPIRED', Colors.orange),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        doc.documentNumber.isEmpty
                            ? 'No document number'
                            : doc.documentNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.event_available_rounded,
                            size: 13,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Expires: ${doc.expiryDate.isEmpty ? '-' : doc.expiryDate}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: expired
                                  ? Colors.orange.shade800
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8ECF3)),
      ),
      child: Column(
        children: [
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Icon(
              Icons.folder_open_rounded,
              size: 38,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No company documents yet',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap New Document to upload your first company file.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded,
              size: 56, color: Colors.red.shade300),
          const SizedBox(height: 12),
          Text(
            'Unable to load documents',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchDocs,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
      ),
    );
  }

  bool _isExpired(String date) {
    try {
      if (date.isEmpty) return false;
      return DateTime.parse(date).isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }
}

class CompanyDocumentDetailScreen extends StatefulWidget {
  final CompanyDocumentModel document;

  const CompanyDocumentDetailScreen({
    super.key,
    required this.document,
  });

  @override
  State<CompanyDocumentDetailScreen> createState() =>
      _CompanyDocumentDetailScreenState();
}

class _CompanyDocumentDetailScreenState
    extends State<CompanyDocumentDetailScreen> {
  late TextEditingController _fileNameController;
  late TextEditingController _docNumberController;
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;

  bool _saving = false;
  bool _loadingDetail = false;
  String? _pickedFileExtension;
  String? _pickedFilePath;
  String? _pickedFileName;
  late CompanyDocumentModel _document;

  @override
  void initState() {
    super.initState();

    _document = widget.document;

    _fileNameController = TextEditingController(text: _document.fileName);
    _docNumberController =
        TextEditingController(text: _document.documentNumber);
    _issueDateController = TextEditingController(text: _document.issueDate);
    _expiryDateController = TextEditingController(text: _document.expiryDate);

    _fetchDetail();
  }

  Future<void> _shareDocumentDetails() async {
    final fileName =
        _document.fileName.isEmpty ? 'Company Document' : _document.fileName;

    final docNumber =
        _document.documentNumber.isEmpty ? '-' : _document.documentNumber;

    final issueDate = _document.issueDate.isEmpty ? '-' : _document.issueDate;

    final expiryDate =
        _document.expiryDate.isEmpty ? '-' : _document.expiryDate;

    final documentUrl =
        _document.documentUrl.isEmpty ? '-' : _document.documentUrl;

    final message = '''
Company Document Details

File Name: $fileName
Document Number: $docNumber
Issue Date: $issueDate
Expiry Date: $expiryDate

Document Link:
$documentUrl
''';

    await Share.share(
      message,
      subject: fileName,
    );
  }

  Future<void> _deleteDocument() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Delete Document?',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _document.fileName.isEmpty
                      ? 'This document will be permanently deleted.'
                      : _document.fileName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.red.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 52),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF101828),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(0, 52),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != true) return;

    try {
      await sl<UsersRepository>().deleteCompanyDocument(_document.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text('Document deleted successfully'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text('Failed: $e'),
        ),
      );
    }
  }

  Future<void> _fetchDetail() async {
    setState(() => _loadingDetail = true);

    try {
      final detail =
          await sl<UsersRepository>().getCompanyDocumentDetail(_document.id);

      if (!mounted) return;

      setState(() {
        _document = detail;
        _fileNameController.text = detail.fileName;
        _docNumberController.text = detail.documentNumber;
        _issueDateController.text = detail.issueDate;
        _expiryDateController.text = detail.expiryDate;
        _loadingDetail = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingDetail = false);
    }
  }

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
    DateTime initialDate = DateTime.now();

    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(controller.text);
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
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

  Future<void> _saveChanges() async {
    if (_pickedFilePath == null) {
      _showSnack('Please select a replacement file');
      return;
    }

    if (_issueDateController.text.trim().isEmpty ||
        _expiryDateController.text.trim().isEmpty) {
      _showSnack('Please select issue and expiry dates');
      return;
    }

    setState(() => _saving = true);

    try {
      final updated = await sl<UsersRepository>().updateCompanyDocument(
        documentId: _document.id,
        filePath: _pickedFilePath!,
        fileName: _finalFileName(),
        documentNumber: _docNumberController.text.trim(),
        issueDate: _issueDateController.text.trim(),
        expiryDate: _expiryDateController.text.trim(),
      );

      if (!mounted) return;

      _showSnack('Document updated successfully');
      Navigator.pop(context, updated);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showSnack('Failed: $e');
    }
  }

  Future<void> _openDocument() async {
    if (_document.documentUrl.isEmpty) {
      _showSnack('No document URL found');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentPreviewScreen(
          title: _document.fileName,
          url: _document.documentUrl,
        ),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool get _isPdf {
    final name = _pickedFileName ?? _document.fileName;
    return name.toLowerCase().endsWith('.pdf');
  }

  bool get _isExpired {
    try {
      if (_document.expiryDate.isEmpty) return false;
      return DateTime.parse(_document.expiryDate).isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _pickedFileName ?? _document.fileName;
    final color = _isExpired
        ? Colors.orange
        : _isPdf
            ? Colors.redAccent
            : AppColors.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: _loadingDetail
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 235,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: color,
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: Text(
                    'Document Details',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: _shareDocumentDetails,
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: _deleteDocument,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: _heroHeader(fileName, color),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
                    child: Column(
                      children: [
                        _quickActions(),
                        const SizedBox(height: 16),
                        _detailsCard(),
                        const SizedBox(height: 16),
                        _replaceFileCard(),
                        const SizedBox(height: 16),
                        _previewCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _bottomButton(),
    );
  }

  Widget _heroHeader(String fileName, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.82),
            const Color(0xFF101828),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(right: -45, top: -25, child: _circle(150)),
          Positioned(left: -35, bottom: -35, child: _circle(115)),
          Positioned(
            left: 20,
            right: 20,
            bottom: 28,
            child: Row(
              children: [
                Container(
                  height: 68,
                  width: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Icon(
                    _isPdf
                        ? Icons.picture_as_pdf_rounded
                        : Icons.description_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isExpired)
                        Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'EXPIRED',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      Text(
                        fileName.isEmpty ? 'Untitled Document' : fileName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _document.documentNumber.isEmpty
                            ? 'No document number'
                            : _document.documentNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12,
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
    );
  }

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _miniInfo(
            title: 'Issue Date',
            value: _document.issueDate.isEmpty ? '-' : _document.issueDate,
            icon: Icons.calendar_today_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _miniInfo(
            title: 'Expiry Date',
            value: _document.expiryDate.isEmpty ? '-' : _document.expiryDate,
            icon: Icons.event_available_rounded,
          ),
        ),
      ],
    );
  }

  Widget _miniInfo({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8ECF3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 21),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF101828),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsCard() {
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

  Widget _replaceFileCard() {
    return _sectionCard(
      title: 'Replacement File',
      icon: Icons.upload_file_rounded,
      child: InkWell(
        onTap: _pickFile,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8ECF3)),
          ),
          child: Row(
            children: [
              Icon(Icons.attach_file_rounded, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _pickedFileName ?? 'Select replacement file',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101828),
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _previewCard() {
    return _sectionCard(
      title: 'Preview',
      icon: Icons.visibility_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _document.documentUrl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _openDocument,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF101828),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
              label: Text(
                'Open Document',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _shareDocumentDetails,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.primary.withOpacity(0.30),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(
                Icons.share_rounded,
                color: AppColors.primary,
              ),
              label: Text(
                'Share Details',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
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
            onPressed: _saving ? null : _saveChanges,
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
                : const Icon(Icons.save_rounded, color: Colors.white),
            label: Text(
              _saving ? 'Saving...' : 'Save Changes',
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
