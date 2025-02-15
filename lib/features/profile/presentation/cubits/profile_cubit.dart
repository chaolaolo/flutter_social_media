import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/profile/domain/entities/profile_user.dart';
import 'package:flutter_social_media/features/profile/domain/repository/profile_repository.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_states.dart';
import 'package:flutter_social_media/features/storage/domain/storagre_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final StorageRepository storageRepository;

  ProfileCubit({
    required this.profileRepository,
    required this.storageRepository,
  }) : super(ProfileInitial());

// fetch user profile using repo -> useful for loading single profile page
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepository.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found!"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  //return user profile given uid -> useful for loading many profiles for posts
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepository.fetchUserProfile(uid);
    return user;
  }

  //update bio or profile image
  Future<void> updateUserProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      // fetch current user first
      final currentUser = await profileRepository.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user profile update!"));
        return;
      }

      // profile image update
      String? imageDownloadUrl;
      if (imageWebBytes != null || imageMobilePath != null) {
        if (imageMobilePath != null) {
          //for mobile
          imageDownloadUrl = await storageRepository.uploadProfileImageMobile(imageMobilePath, uid);
        } else if (imageWebBytes != null) {
          //for web
          imageDownloadUrl = await storageRepository.uploadProfileImageWeb(imageWebBytes, uid);
        }
        if(imageDownloadUrl == null){
          emit(ProfileError("Failed to upload profile image!"));
          return;
        }
      }

      //update new profile
      final updatedProfileUser = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      // update in repo
      await profileRepository.updateUserProfile(updatedProfileUser);

      //re-fetch the updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }

  //toggle follow/unfollow
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      await profileRepository.toggleFollow(currentUid, targetUid);
    } catch (e) {
      emit(ProfileError("Error toggling follow: $e"));
    }
  }
}
