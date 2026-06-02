class UserModel {
  final String id;
  final String username;
  final String? fullName;
  final String? empId;
  final String? email;
  final String? roleName;
  final String? status;
  final String? profilePicture;
  final String? saudiPhone;
  final String? address;
  UserModel({
    required this.id,
    required this.username,
    this.fullName,
    this.empId,
    this.email,
    this.roleName,
    this.saudiPhone,
    this.address,
    this.status,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      saudiPhone: json['saudi_phone'] ?? '',
      address: json['address'] ?? '',
      fullName: json['full_name'],
      empId: json['emp_id']?.toString(), // ✅ FIX
      email: json['email'],
      roleName: json['role_name']??'',
      status: json['status'],
      profilePicture: json['profile_picture'],
    );
  }
}