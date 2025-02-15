import 'package:flutter_social_media/features/profile/domain/entities/profile_user.dart';

abstract class SearchRepository {
  Future<List<ProfileUser>> searchUsers(String query);
}