import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/post/domain/entities/comment.dart';
import 'package:flutter_social_media/features/post/domain/entities/post.dart';
import 'package:flutter_social_media/features/post/domain/repository/post_repository.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_states.dart';
import 'package:flutter_social_media/features/storage/domain/storagre_repository.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;
  final StorageRepository storageRepository;

  PostCubit({
    required this.postRepository,
    required this.storageRepository,
  }) : super(PostsInitial());

  //create a new post
  Future<void> createPost(Post post, {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;
    try {
      if (imagePath != null) {
        //handle image upload for mobile platforms (using file path)
        emit(PostUploading());
        imageUrl = await storageRepository.uploadPostImageMobile(imagePath, post.id);
      } else if (imageBytes != null) {
        //handle image upload for mobile platforms (using file path)
        emit(PostUploading());
        imageUrl = await storageRepository.uploadPostImageWeb(imageBytes, post.id);
      }

      //give imageUrl to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      //create post in the backend
      postRepository.createPost(newPost);

      //re-fetch posts
      fetchAllPosts();
    } catch (e) {
      emit(PostsError('Failed to create post: $e'));
    }
  } //end create post

  //fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepository.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError('Failed to fetch posts: $e'));
    }
  } //end fetch all posts

  //delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepository.deletePost(postId);
    } catch (e) {
      emit(PostsError('Failed to delete post: $e'));
    }
  } //end delete post

  //toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepository.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError('Failed to toggle like: $e'));
    }
  } //end like post

  // add a comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepository.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError('Failed to add comment: $e'));
    }
  }
  // delete comment on a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepository.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError('Failed to delete comment: $e'));
    }
  }
}
