// lib/features/users/presentation/user_details_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/users/model/user_model.dart';
import 'package:ipsum_user/features/users/user_document_screen.dart';
import 'package:ipsum_user/features/users/user_visiting_card_screen.dart';

class UserDetailsScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailsScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final name = _displayName(user);
    final initials = _buildInitials(name);

    final role = (user.roleName ?? '').trim();
    final email = (user.email ?? '').trim();
    final phone = (user.saudiPhone ?? '').trim();
    final address = (user.address ?? '').trim();
    final status = (user.status ?? '').trim();
    final imageUrl = (user.profilePicture ?? '').trim();

    final isActive = status.toLowerCase() == 'active';
    final statusColor = isActive ? const Color(0xFF18A558) : Colors.redAccent;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: Text(
          'User Details',
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
              _profileHeader(
                name: name,
                initials: initials,
                role: role,
                email: email,
                status: status,
                statusColor: statusColor,
                imageUrl: imageUrl,
              ),

              const SizedBox(height: 16),

              _sectionCard(
                title: 'Contact Information',
                children: [
                  if (phone.isNotEmpty)
                    _infoTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: phone,
                    ),
                  if (email.isNotEmpty)
                    _infoTile(
                      icon: Icons.email_outlined,
                      label: 'Email Address',
                      value: email,
                    ),
                  if (address.isNotEmpty)
                    _infoTile(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value: address,
                    ),
                  if (phone.isEmpty && email.isEmpty && address.isEmpty)
                    _emptyText('No contact information available'),
                ],
              ),

              const SizedBox(height: 16),

              _sectionCard(
                title: 'Account Information',
                children: [
                  _infoTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Username',
                    value: user.username,
                  ),
                  if ((user.id ?? '').isNotEmpty)
                    _infoTile(
                      icon: Icons.badge_outlined,
                      label: 'User ID',
                      value: user.id ?? '',
                    ),
                  if (role.isNotEmpty)
                    _infoTile(
                      icon: Icons.work_outline_rounded,
                      label: 'Role',
                      value: role,
                    ),
                  if (status.isNotEmpty)
                    _infoTile(
                      icon: Icons.verified_user_outlined,
                      label: 'Status',
                      value: status,
                      valueColor: statusColor,
                    ),
                ],
              ),

              const SizedBox(height: 16),

              _sectionCard(
                title: 'Quick Actions',
                children: [
                  _actionTile(
                    icon: Icons.badge_outlined,
                    title: 'View Visiting Card',
                    subtitle: 'Preview and share visiting card',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserVisitingCardScreen(user: user),
                        ),
                      );
                    },
                  ),
                  _actionTile(
                    icon: Icons.description_outlined,
                    title: 'View Documents',
                    subtitle: 'Check uploaded user documents',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserDocumentsScreen(user: user),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader({
    required String name,
    required String initials,
    required String role,
    required String email,
    required String status,
    required Color statusColor,
    required String imageUrl,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 92,
                width: 92,
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return _fallbackAvatar(initials);
                          },
                        )
                      : _fallbackAvatar(initials),
                ),
              ),
              if (status.isNotEmpty)
                Positioned(
                  right: 4,
                  bottom: 6,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          if (role.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              role,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.82),
              ),
            ),
          ],
          if (email.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              email,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                color: Colors.white.withOpacity(0.72),
              ),
            ),
          ],
          if (status.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Text(
                status,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9ECF2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF151522),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE9ECF2)),
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: valueColor ?? const Color(0xFF151522),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF151522),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fallbackAvatar(String initials) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.poppins(
          fontSize: 28,
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _emptyText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
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
}