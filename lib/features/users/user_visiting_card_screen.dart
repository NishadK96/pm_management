// // lib/features/users/user_visiting_card_screen.dart

// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ipsum_user/core/theme/app_colors.dart';
// import 'package:ipsum_user/features/users/model/user_model.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// class UserVisitingCardScreen extends StatefulWidget {
//   final UserModel user;

//   const UserVisitingCardScreen({
//     super.key,
//     required this.user,
//   });

//   @override
//   State<UserVisitingCardScreen> createState() => _UserVisitingCardScreenState();
// }

// class _UserVisitingCardScreenState extends State<UserVisitingCardScreen> {
//   final GlobalKey _cardKey = GlobalKey();
//   bool _saving = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.5,
//         title: Text(
//           'Visiting Card',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF151522),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               const SizedBox(height: 24),
//               RepaintBoundary(
//                 key: _cardKey,
//                 child: _PremiumVisitingCard(user: widget.user),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton.icon(
//                   onPressed: _saving ? null : _saveAndShareCardImage,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   icon: _saving
//                       ? const SizedBox(
//                           width: 17,
//                           height: 17,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation(Colors.white),
//                           ),
//                         )
//                       : const Icon(
//                           Icons.ios_share_rounded,
//                           color: Colors.white,
//                         ),
//                   label: Text(
//                     _saving ? 'Generating...' : 'Share Visiting Card',
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _saveAndShareCardImage() async {
//     try {
//       setState(() => _saving = true);

//       final boundary =
//           _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

//       final image = await boundary.toImage(pixelRatio: 4);
//       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       final pngBytes = byteData!.buffer.asUint8List();

//       final dir = await getTemporaryDirectory();
//       final file = File(
//         '${dir.path}/visiting_card_${widget.user.username}_${DateTime.now().millisecondsSinceEpoch}.png',
//       );

//       await file.writeAsBytes(pngBytes);

//       await Share.shareXFiles(
//         [XFile(file.path)],
//         text: 'Visiting card - ${_displayName(widget.user)}',
//       );
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to generate image: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }
// }

// class _PremiumVisitingCard extends StatelessWidget {
//   final UserModel user;

//   static const String _appLogo = 'assets/icon/logo_bg.png';
//   static const String _companyName = 'SHAMS HAIL';
//   static const String _companySubName = 'Trading Co.';

//   const _PremiumVisitingCard({
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final name = _displayName(user);
//     final initials = _buildInitials(name);

//     final role = (user.roleName ?? '').trim();
//     final email = (user.email ?? '').trim();
//     final phone = (user.saudiPhone ?? '').trim();
//     final address = (user.address ?? '').trim();
//     final imageUrl = (user.profilePicture ?? '').trim();

//     return Container(
//       width: 370,
//       height: 245,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x22000000),
//             blurRadius: 22,
//             offset: Offset(0, 10),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Stack(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 124,
//                   color: AppColors.primary,
//                 ),
//                 Expanded(
//                   child: Container(
//                     color: const Color(0xFF101828),
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               right: -35,
//               top: -35,
//               child: Container(
//                 height: 115,
//                 width: 115,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white.withOpacity(0.035),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 92,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 78,
//                           width: 78,
//                           padding: const EdgeInsets.all(3),
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: ClipOval(
//                             child: imageUrl.isNotEmpty
//                                 ? Image.network(
//                                     imageUrl,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (_, __, ___) =>
//                                         _initialAvatar(initials),
//                                   )
//                                 : _initialAvatar(initials),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 18),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _companyHeader(),
//                           const SizedBox(height: 14),
//                           Text(
//                             name.toUpperCase(),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.white,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                           if (role.isNotEmpty) ...[
//                             const SizedBox(height: 2),
//                             Text(
//                               role,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 10,
//                                 color: Colors.white.withOpacity(0.62),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                           const SizedBox(height: 10),
//                           if (phone.isNotEmpty)
//                             _contactLine(Icons.phone_outlined, phone),
//                           if (email.isNotEmpty)
//                             _contactLine(Icons.email_outlined, email),
//                           if (address.isNotEmpty)
//                             _contactLine(
//                               Icons.location_on_outlined,
//                               address,
//                               maxLines: 1,
//                             ),
//                           const Spacer(),
//                           Container(
//                             width: 68,
//                             height: 3,
//                             decoration: BoxDecoration(
//                               color: AppColors.primary,
//                               borderRadius: BorderRadius.circular(99),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _companyHeader() {
//     return Row(
//       children: [
//         Container(
//           height: 30,
//           width: 30,
//           // padding: const EdgeInsets.all(5),
//           // decoration: BoxDecoration(
//           //   color: Colors.white,
//           //   borderRadius: BorderRadius.circular(11),
//           // ),
//           child: Image.asset(
//             _appLogo,
//             fit: BoxFit.contain,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 _companyName,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.poppins(
//                   fontSize: 10.5,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 0.4,
//                 ),
//               ),
//               Text(
//                 _companySubName,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.poppins(
//                   fontSize: 8.5,
//                   color: Colors.white.withOpacity(0.58),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _contactLine(
//     IconData icon,
//     String text, {
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: Row(
//         children: [
//           Container(
//             height: 23,
//             width: 23,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               icon,
//               size: 13,
//               color: Colors.white.withOpacity(0.75),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               maxLines: maxLines,
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.poppins(
//                 fontSize: 9.8,
//                 color: Colors.white.withOpacity(0.86),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _initialAvatar(String initials) {
//     return Container(
//       alignment: Alignment.center,
//       color: Colors.white,
//       child: Text(
//         initials,
//         style: GoogleFonts.poppins(
//           fontSize: 23,
//           fontWeight: FontWeight.w800,
//           color: AppColors.primary,
//         ),
//       ),
//     );
//   }

//   String _buildInitials(String name) {
//     final parts = name.split(' ').where((p) => p.trim().isNotEmpty).toList();

//     if (parts.isEmpty) return '?';
//     if (parts.length == 1) return parts.first[0].toUpperCase();

//     return (parts[0][0] + parts[1][0]).toUpperCase();
//   }
// }

// String _displayName(UserModel user) {
//   return (user.fullName?.trim().isNotEmpty == true)
//       ? user.fullName!.trim()
//       : user.username;
// }

// lib/features/users/user_visiting_card_screen.dart

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/users/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum VisitingCardPreset {
  darkPremium,
  cleanWhite,
  blueCorporate,
}

class UserVisitingCardScreen extends StatefulWidget {
  final UserModel user;

  const UserVisitingCardScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserVisitingCardScreen> createState() => _UserVisitingCardScreenState();
}

class _UserVisitingCardScreenState extends State<UserVisitingCardScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _saving = false;

  VisitingCardPreset _selectedPreset = VisitingCardPreset.darkPremium;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Visiting Card',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF151522),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _presetSelector(),
              const SizedBox(height: 22),
              RepaintBoundary(
                key: _cardKey,
                child: VisitingCardPresetView(
                  user: widget.user,
                  preset: _selectedPreset,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _saveAndShareCardImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.ios_share_rounded,
                          color: Colors.white,
                        ),
                  label: Text(
                    _saving ? 'Generating...' : 'Share Selected Card',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _presetSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9ECF2)),
      ),
      child: Row(
        children: [
          _presetChip('Dark', VisitingCardPreset.darkPremium),
          _presetChip('White', VisitingCardPreset.cleanWhite),
          _presetChip('Blue', VisitingCardPreset.blueCorporate),
        ],
      ),
    );
  }

  Widget _presetChip(String label, VisitingCardPreset preset) {
    final selected = _selectedPreset == preset;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPreset = preset;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF151522),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveAndShareCardImage() async {
    try {
      setState(() => _saving = true);

      final boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 4);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/visiting_card_${widget.user.username}_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Visiting card - ${_displayName(widget.user)}',
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate image: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class VisitingCardPresetView extends StatelessWidget {
  final UserModel user;
  final VisitingCardPreset preset;

  const VisitingCardPresetView({
    super.key,
    required this.user,
    required this.preset,
  });

  @override
  Widget build(BuildContext context) {
    switch (preset) {
      case VisitingCardPreset.darkPremium:
        return DarkPremiumCard(user: user);
      case VisitingCardPreset.cleanWhite:
        return CleanWhiteCard(user: user);
      case VisitingCardPreset.blueCorporate:
        return BlueCorporateCard(user: user);
    }
  }
}

class CleanWhiteCard extends StatelessWidget {
  final UserModel user;

  static const String logo = 'assets/icon/logo_bg.png';

  const CleanWhiteCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final data = CardData.fromUser(user);

    return Container(
      width: 370,
      height: 240,
      decoration: _cardShadow(color: Colors.white),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              bottom: -50,
              child: _decorCircle(150, AppColors.primary.withOpacity(0.08)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        logo,
                        height: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'SHAMS HAIL\nTrading Co.',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF151522),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _profileImage(data, dark: false),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF151522),
                              ),
                            ),
                            if (data.role.isNotEmpty)
                              Text(
                                data.role,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (data.phone.isNotEmpty)
                    _contactLineLight(Icons.phone_outlined, data.phone),
                  if (data.email.isNotEmpty)
                    _contactLineLight(Icons.email_outlined, data.email),
                  if (data.address.isNotEmpty)
                    _contactLineLight(
                      Icons.location_on_outlined,
                      data.address,
                      maxLines: 1,
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

class CardData {
  final String name;
  final String initials;
  final String role;
  final String email;
  final String phone;
  final String address;
  final String imageUrl;

  CardData({
    required this.name,
    required this.initials,
    required this.role,
    required this.email,
    required this.phone,
    required this.address,
    required this.imageUrl,
  });

  factory CardData.fromUser(UserModel user) {
    final name = _displayName(user);

    return CardData(
      name: name,
      initials: _buildInitials(name),
      role: (user.roleName ?? '').trim(),
      email: (user.email ?? '').trim(),
      phone: (user.saudiPhone ?? '').trim(),
      address: (user.address ?? '').trim(),
      imageUrl: (user.profilePicture ?? '').trim(),
    );
  }
}

class DarkPremiumCard extends StatelessWidget {
  final UserModel user;

  static const String logo = 'assets/icon/logo_bg.png';

  const DarkPremiumCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final data = CardData.fromUser(user);

    return Container(
      width: 370,
      height: 240,
      decoration: _cardShadow(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Row(
              children: [
                Container(width: 124, color: AppColors.primary),
                Expanded(child: Container(color: const Color(0xFF101828))),
              ],
            ),
            Positioned(
              right: -38,
              top: -38,
              child: _decorCircle(120, Colors.white.withOpacity(0.04)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 92,
                    child: Center(
                      child: _profileImage(data),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _companyHeaderDark(),
                          const SizedBox(height: 15),
                          Text(
                            data.name.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          if (data.role.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              data.role,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                color: Colors.white.withOpacity(0.65),
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          if (data.phone.isNotEmpty)
                            _contactLineDark(Icons.phone_outlined, data.phone),
                          if (data.email.isNotEmpty)
                            _contactLineDark(Icons.email_outlined, data.email),
                          if (data.address.isNotEmpty)
                            _contactLineDark(
                              Icons.location_on_outlined,
                              data.address,
                              maxLines: 1,
                            ),
                          const Spacer(),
                          Container(
                            width: 72,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _companyHeaderDark() {
    return Row(
      children: [
        Container(
          height: 34,
          width: 34,
          padding: const EdgeInsets.all(5),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(11),
          // ),
          child: Image.asset(logo, fit: BoxFit.contain),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'SHAMS HAIL\nTrading Co.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10,
              height: 1.15,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class BlueCorporateCard extends StatelessWidget {
  final UserModel user;

  static const String logo = 'assets/icon/logo_bg.png';

  const BlueCorporateCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final data = CardData.fromUser(user);

    return Container(
      width: 370,
      height: 240,
      decoration: _cardShadow(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    const Color(0xFF0B3B75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -55,
              bottom: -70,
              child: _decorCircle(180, Colors.white.withOpacity(0.08)),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _profileImage(data),
                      const SizedBox(height: 12),
                      Container(
                        height: 36,
                        width: 82,
                        padding: const EdgeInsets.all(6),
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   borderRadius: BorderRadius.circular(13),
                        // ),
                        child: Image.asset(logo, fit: BoxFit.contain),
                      ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          'SHAMS HAIL Trading Co.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.75),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        if (data.role.isNotEmpty)
                          Text(
                            data.role,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                        const SizedBox(height: 13),
                        if (data.phone.isNotEmpty)
                          _contactLineDark(Icons.phone_outlined, data.phone),
                        if (data.email.isNotEmpty)
                          _contactLineDark(Icons.email_outlined, data.email),
                        if (data.address.isNotEmpty)
                          _contactLineDark(
                            Icons.location_on_outlined,
                            data.address,
                            maxLines: 1,
                          ),
                        const Spacer(),
                      ],
                    ),
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

BoxDecoration _cardShadow({Color? color}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(24),
    boxShadow: const [
      BoxShadow(
        color: Color(0x22000000),
        blurRadius: 22,
        offset: Offset(0, 10),
      ),
    ],
  );
}

Widget _decorCircle(double size, Color color) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}

Widget _profileImage(CardData data, {bool dark = true}) {
  return Container(
    height: 78,
    width: 78,
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
        color: dark ? Colors.white : AppColors.primary.withOpacity(0.20),
      ),
    ),
    child: ClipOval(
      child: data.imageUrl.isNotEmpty
          ? Image.network(
              data.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _initialAvatar(data.initials),
            )
          : _initialAvatar(data.initials),
    ),
  );
}

Widget _initialAvatar(String initials) {
  return Container(
    alignment: Alignment.center,
    color: Colors.white,
    child: Text(
      initials,
      style: GoogleFonts.poppins(
        fontSize: 23,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
    ),
  );
}

Widget _contactLineDark(
  IconData icon,
  String text, {
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Container(
          height: 22,
          width: 22,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 13,
            color: Colors.white.withOpacity(0.75),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 9.5,
              color: Colors.white.withOpacity(0.86),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _contactLineLight(
  IconData icon,
  String text, {
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 13,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: const Color(0xFF344054),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

String _displayName(UserModel user) {
  return (user.fullName?.trim().isNotEmpty == true)
      ? user.fullName!.trim()
      : user.username;
}

String _buildInitials(String name) {
  final parts = name.split(' ').where((p) => p.trim().isNotEmpty).toList();

  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first[0].toUpperCase();

  return (parts[0][0] + parts[1][0]).toUpperCase();
}
