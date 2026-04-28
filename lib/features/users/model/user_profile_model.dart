class UserProfileModel {
  final String id;
  final String username;
  final String? fullName;
  final String? empId;
  final String? nativePhone;
  final String? saudiPhone;
  final String? permanentPhone;
  final String email;
  final String? joinDate;
  final String? duration;
  final String? iqamaNumber;
  final String? iqamaExpiry;
  final String? baladiyaNumber;
  final String? baladiyaExpiry;
  final String? insuranceNumber;
  final String? insuranceExpiry;
  final String? passportNumber;
  final String? passportExpiry;
  final String? profilePicture;
  final String? roleName; // from roles[0].role_name
  final String? address;
  final String status;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.status,
    this.fullName,
    this.empId,
    this.nativePhone,
    this.saudiPhone,
    this.permanentPhone,
    this.joinDate,
    this.duration,
    this.iqamaNumber,
    this.iqamaExpiry,
    this.baladiyaNumber,
    this.baladiyaExpiry,
    this.insuranceNumber,
    this.insuranceExpiry,
    this.passportNumber,
    this.passportExpiry,
    this.profilePicture,
    this.roleName,
    this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // roles: [{ "role_name": "Co-Ordinator" }]
    String? roleName;
    final roles = json['roles'] as List<dynamic>?;
    if (roles != null && roles.isNotEmpty) {
      final first = roles.first as Map<String, dynamic>;
      roleName = first['role_name'] as String?;
    }

    return UserProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['full_name'] as String?,
      empId: json['emp_id'] as String?,
      nativePhone: json['native_phone'] as String?,
      saudiPhone: json['saudi_phone'] as String?,
      permanentPhone: json['permanent_phone'] as String?,
      email: json['email'] as String,
      joinDate: json['join_date'] as String?,
      duration: json['duration'] as String?,
      iqamaNumber: json['iqama_number'] as String?,
      iqamaExpiry: json['iqama_expiry'] as String?,
      baladiyaNumber: json['baladiya_number'] as String?,
      baladiyaExpiry: json['baladiya_expiry'] as String?,
      insuranceNumber: json['insurance_number'] as String?,
      insuranceExpiry: json['insurance_expiry'] as String?,
      passportNumber: json['passport_number'] as String?,
      passportExpiry: json['passport_expiry'] as String?,
      profilePicture: json['profile_picture'] as String?,
      roleName: roleName,
      address: json['address'] as String?,
      status: json['status'] as String,
    );
  }
}