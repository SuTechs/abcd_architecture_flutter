import 'dart:developer';

import '../../data/user/user.dart';
import 'firebase_service.dart';

// -------------------------USER-------------------------- //

/// Extension for managing the User Collection in FireStore.
extension UserService on FirebaseService {
  static const collectionName = FireIds.user;

  /// Retrieves user data by user ID.
  Future<UserData?> getUser(String userId) async {
    try {
      final data = await getDoc([collectionName, userId]);
      return data != null ? UserData.fromJson(data) : null;
    } catch (e) {
      log('Error getting user data: $e');
      return null;
    }
  }

  /// Adds a new user to the User Collection.
  Future<String?> addUser(UserData user) async {
    try {
      return await addDoc([collectionName], user.toJson(), documentId: user.id);
    } catch (e) {
      log('Error adding user: $e');
      return null;
    }
  }

  /// Updates an existing user in the User Collection.
  Future<void> updateUser(UserData user) async {
    try {
      await updateDoc([collectionName, user.id], user.toJson());
    } catch (e) {
      log('Error updating user: $e');
    }
  }

  ///upload images
  Future<String?> uploadProfilePic(String filePath) =>
      uploadFile(filePath, 'pic.png');
}
