import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_media/features/profile/domain/entities/profile_user.dart';
import 'package:flutter_social_media/features/profile/domain/repository/profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // get user document from firestore
      final userDoc = await firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          return ProfileUser(
            uid: uid,
            email: userData["email"],
            name: userData["name"],
            bio: userData["bio"] ?? "",
            profileImageUrl: userData["profileImageUrl"].toString(),
          );
        }
      }
      return null;
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(ProfileUser updatedProfileUser) async {
    try {
      //convert updated profile user to json to tore in firestore
      await firebaseFirestore.collection('users').doc(updatedProfileUser.uid).update({
        "bio": updatedProfileUser.bio,
        "profileImageUrl": updatedProfileUser.profileImageUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
