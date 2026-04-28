import 'package:ipsum_user/features/users/data/datasources/users_data_source.dart';
import 'package:ipsum_user/features/users/model/user_document_model.dart';
import 'package:ipsum_user/features/users/model/user_model.dart';
import 'package:ipsum_user/features/users/model/user_profile_model.dart';

class UsersRepository {
  final UsersDataSource dataSource;

  UsersRepository({required this.dataSource});

  Future<List<UserModel>> getAllUsers() {
    return dataSource.getAllUsers();
  }
  Future<UserDocumentModel> updateUserDocument({
    required String userId,
    required String documentId,
    required String filePath,
    required String fileName,
    required String documentNumber,
    required String issueDate,
    required String expiryDate,
  }) {
    return dataSource.updateUserDocument(
      userId: userId,
      documentId: documentId,
      filePath: filePath,
      fileName: fileName,
      documentNumber: documentNumber,
      issueDate: issueDate,
      expiryDate: expiryDate,
    );
  }
 Future<List<UserDocumentModel>> getUserDocuments(String userId) {
    return dataSource.getUserDocuments(userId);
  }
  // 🔹 NEW
  Future<UserProfileModel> getUserProfile(String userId) {
    return dataSource.getUserProfile(userId);
  }
}