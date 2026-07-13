import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/local/app_prefs.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/login/login.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/features/users/model/user_model.dart';
import 'package:ipsum_user/features/users/model/user_profile_model.dart';
import 'package:ipsum_user/features/users/user_visiting_card_screen.dart';
import 'package:ipsum_user/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  UserProfileModel? _profile;
  bool _loading = true;
  bool _canViewVisitingCard(UserProfileModel profile) {
    final role = (profile.roleName ?? '').toLowerCase().trim();

    return role == 'chairman' || role == 'director' || role == 'coordinator';
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final appPrefs = sl<AppPrefs>();
    final userId = appPrefs.userId;

    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      final repo = sl<UsersRepository>();
      final profile = await repo.getUserProfile(userId);

      if (mounted) {
        setState(() {
          _profile = profile;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF151522),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
              ? _emptyState()
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _profileHeader(profile),
                        const SizedBox(height: 16),
                        if (_canViewVisitingCard(profile)) ...[
                          _actionCard(
                            icon: Icons.badge_outlined,
                            title: 'My Visiting Card',
                            subtitle: 'Preview and share your visiting card',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserVisitingCardScreen(
                                    user: _profileToUser(profile),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 16),
                        _sectionCard(
                          title: 'Contact Information',
                          children: [
                            _infoTile(
                                Icons.email_outlined, 'Email', profile.email),
                            _infoTile(Icons.phone_outlined, 'Saudi Phone',
                                profile.saudiPhone ?? '-'),
                            _infoTile(Icons.call_outlined, 'Native Phone',
                                profile.nativePhone ?? '-'),
                            _infoTile(
                                Icons.phone_android_outlined,
                                'Permanent Phone',
                                profile.permanentPhone ?? '-'),
                            _infoTile(Icons.location_on_outlined, 'Address',
                                profile.address ?? '-'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _sectionCard(
                          title: 'Work Information',
                          children: [
                            _infoTile(Icons.work_outline_rounded, 'Designation',
                                profile.roleName ?? '-'),
                            _infoTile(Icons.calendar_today_outlined,
                                'Join Date', profile.joinDate ?? '-'),
                            _infoTile(Icons.timelapse_outlined, 'Duration',
                                profile.duration ?? '-'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _sectionCard(
                          title: 'Document Information',
                          children: [
                            _infoTile(Icons.credit_card_outlined,
                                'Iqama Number', profile.iqamaNumber ?? '-'),
                            _infoTile(Icons.event_available_outlined,
                                'Iqama Expiry', profile.iqamaExpiry ?? '-'),
                            _infoTile(
                                Icons.assignment_outlined,
                                'Baladiya Number',
                                profile.baladiyaNumber ?? '-'),
                            _infoTile(Icons.event_outlined, 'Baladiya Expiry',
                                profile.baladiyaExpiry ?? '-'),
                            _infoTile(
                                Icons.health_and_safety_outlined,
                                'Insurance Number',
                                profile.insuranceNumber ?? '-'),
                            _infoTile(
                                Icons.event_note_outlined,
                                'Insurance Expiry',
                                profile.insuranceExpiry ?? '-'),
                            _infoTile(Icons.public_outlined, 'Passport Number',
                                profile.passportNumber ?? '-'),
                            _infoTile(
                                Icons.calendar_month_outlined,
                                'Passport Expiry',
                                profile.passportExpiry ?? '-'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.logout_rounded,
                                color: Colors.white),
                            label: Text(
                              'Logout',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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

  Widget _profileHeader(UserProfileModel profile) {
    final name = profile.fullName?.trim().isNotEmpty == true
        ? profile.fullName!.trim()
        : profile.username ?? 'User';

    final initials = _initials(name);
    final imageUrl = profile.profilePicture ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            color: AppColors.primary.withOpacity(0.24),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 98,
            width: 98,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _avatarFallback(initials),
                    )
                  : _avatarFallback(initials),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.roleName ?? '-',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withOpacity(0.82),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            profile.email,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              color: Colors.white.withOpacity(0.72),
            ),
          ),
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

  Widget _infoTile(IconData icon, String label, String value) {
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
            child: Icon(icon, color: AppColors.primary, size: 20),
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
                  value.isEmpty ? '-' : value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF151522),
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

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE9ECF2)),
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
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
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarFallback(String initials) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Text(
        'Profile not found',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.split(' ').where((e) => e.trim().isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  UserModel _profileToUser(UserProfileModel profile) {
    return UserModel(
      id: profile.id ?? '',
      username: profile.username ?? '',
      fullName: profile.fullName,
      email: profile.email,
      roleName: profile.roleName,
      status: 'active',
      address: profile.address,
      saudiPhone: profile.saudiPhone,
      profilePicture: profile.profilePicture,
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final appPrefs = AppPrefs(prefs);
    await appPrefs.clearSession();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
  }
}
