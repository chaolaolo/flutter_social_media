
import 'package:flutter_social_media/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepository {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateUserProfile(ProfileUser updatedProfileUser);

  Future<void> toggleFollow(String currentUid, String targetUid);
}