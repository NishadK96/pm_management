import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/local/app_prefs.dart';

import 'package:ipsum_user/core/widgets/custom_textfield.dart';
import 'package:ipsum_user/core/widgets/long_button.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/login/login.dart';

import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/features/users/model/user_profile_model.dart';

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

  final _fullNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _nativePhoneCtrl = TextEditingController();
  final _saudiPhoneCtrl = TextEditingController();
  final _permanentPhoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _joinDateCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _iqamaNumberCtrl = TextEditingController();
  final _iqamaExpiryCtrl = TextEditingController();
  final _baladiyaNumberCtrl = TextEditingController();
  final _baladiyaExpiryCtrl = TextEditingController();
  final _insuranceNumberCtrl = TextEditingController();
  final _insuranceExpiryCtrl = TextEditingController();
  final _passportNumberCtrl = TextEditingController();
  final _passportExpiryCtrl = TextEditingController();

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
      final prof = await repo.getUserProfile(userId);
      _fillControllers(prof);
      if (mounted) {
        setState(() {
          _profile = prof;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fillControllers(UserProfileModel p) {
    _fullNameCtrl.text = p.fullName ?? '';
    _addressCtrl.text = p.address ?? '';
    _nativePhoneCtrl.text = p.nativePhone ?? '';
    _saudiPhoneCtrl.text = p.saudiPhone ?? '';
    _permanentPhoneCtrl.text = p.permanentPhone ?? '';
    _emailCtrl.text = p.email;
    _joinDateCtrl.text = p.joinDate ?? '';
    _durationCtrl.text = p.duration ?? '';
    _designationCtrl.text = p.roleName ?? '';
    _iqamaNumberCtrl.text = p.iqamaNumber ?? '';
    _iqamaExpiryCtrl.text = p.iqamaExpiry ?? '';
    _baladiyaNumberCtrl.text = p.baladiyaNumber ?? '';
    _baladiyaExpiryCtrl.text = p.baladiyaExpiry ?? '';
    _insuranceNumberCtrl.text = p.insuranceNumber ?? '';
    _insuranceExpiryCtrl.text = p.insuranceExpiry ?? '';
    _passportNumberCtrl.text = p.passportNumber ?? '';
    _passportExpiryCtrl.text = p.passportExpiry ?? '';
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _addressCtrl.dispose();
    _nativePhoneCtrl.dispose();
    _saudiPhoneCtrl.dispose();
    _permanentPhoneCtrl.dispose();
    _emailCtrl.dispose();
    _joinDateCtrl.dispose();
    _durationCtrl.dispose();
    _designationCtrl.dispose();
    _iqamaNumberCtrl.dispose();
    _iqamaExpiryCtrl.dispose();
    _baladiyaNumberCtrl.dispose();
    _baladiyaExpiryCtrl.dispose();
    _insuranceNumberCtrl.dispose();
    _insuranceExpiryCtrl.dispose();
    _passportNumberCtrl.dispose();
    _passportExpiryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TitleWidget(label: 'Profile Details'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 160,
                          height: 181,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: _profile?.profilePicture != null
                                  ? NetworkImage(_profile!.profilePicture!)
                                  : const NetworkImage(
                                      "https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg?w=2000",
                                    ) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 3, color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: SvgPicture.string(
                              IconConst().editProfile),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Full Name",
                      controller: _fullNameCtrl,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Address",
                      controller: _addressCtrl,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Contact in native place",
                            controller: _nativePhoneCtrl,
                            readOnly: true,
                          ),
                        ),
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Contact in Saudi",
                            controller: _saudiPhoneCtrl,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Permanent contact number",
                      controller: _permanentPhoneCtrl,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Email",
                      controller: _emailCtrl,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Join Date",
                            controller: _joinDateCtrl,
                            readOnly: true,
                          ),
                        ),
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Duration",
                            controller: _durationCtrl,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Designation",
                            controller: _designationCtrl,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Iqama Number",
                            controller: _iqamaNumberCtrl,
                            readOnly: true,
                          ),
                        ),
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Expiry",
                            controller: _iqamaExpiryCtrl,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Baladiya Number",
                            controller: _baladiyaNumberCtrl,
                            readOnly: true,
                          ),
                        ),
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Expiry",
                            controller: _baladiyaExpiryCtrl,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Insurance number",
                            controller: _insuranceNumberCtrl,
                            readOnly: true,
                          ),
                        ),
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Expiry",
                            controller: _insuranceExpiryCtrl,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Passport Number",
                            controller: _passportNumberCtrl,
                            readOnly: true,
                          ),
                        ),
                        SizedBox(
                          width: w / 2.3,
                          child: CustomTextField(
                            label: "Expiry",
                            controller: _passportExpiryCtrl,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LongButton(
                      label: "Logout",
                      onTap: () async {
                        final prefs =
                            await SharedPreferences.getInstance();
                        final appPrefs = AppPrefs(prefs);
                        appPrefs.clearSession();
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}