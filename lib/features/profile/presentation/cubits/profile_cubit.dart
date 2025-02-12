import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/profile/domain/entities/profile_user.dart';
import 'package:flutter_social_media/features/profile/domain/repository/profile_repository.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit({
    required this.profileRepository,
  }) : super(ProfileInitial());

// fetch user profile using repo
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

  //update bio or profile image
  Future<void> updateUserProfile({required String uid, String? newBio}) async {
    emit(ProfileLoading());
    try {
      // fetch current user first
      final currentUser = await profileRepository.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user profile update!"));
        return;
      }

      // profile image update

      //update new profile
      final updatedProfileUser = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
      );

      // update in repo
      await profileRepository.updateUserProfile(updatedProfileUser);

      //re-fetch the updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }
}
