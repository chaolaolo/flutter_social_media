import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/domain/entities/app_user.dart';
import 'package:flutter_social_media/features/auth/presentation/components/my_text_field.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_social_media/features/post/domain/entities/comment.dart';
import 'package:flutter_social_media/features/post/domain/entities/post.dart';
import 'package:flutter_social_media/features/post/presentation/components/comment_tile.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_cubit.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_states.dart';
import 'package:flutter_social_media/features/profile/domain/entities/profile_user.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:flutter_social_media/features/profile/presentation/pages/profile_page.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //is own post
  bool isOwnPost = false;

  //current user
  AppUser? currentUser;

  //post user
  ProfileUser? postUser;

  // on startup
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  //get current user method
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = widget.post.userId == currentUser!.uid;
  }

  //fetch post user method
  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  //like/unlike post method
  void toggleLikePost() {
    //current like status
    final isLike = widget.post.likes.contains(currentUser!.uid);
    //optimistically like & update UI
    setState(() {
      if (isLike) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });
    //update like
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((error) {
      // if there's an error, undo the like
      setState(() {
        if (isLike) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  // COMMENT CODE HERE
  // text controller
  final commentTextController = TextEditingController();

  // open comment box to type some comment
  void openNewCommentBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: MyTextField(
                controller: commentTextController,
                hintText: 'Write a comment..',
                obscureText: false,
              ),
              actions: [
                //cancel button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                ),
                //save comment button
                TextButton(
                  onPressed: () {
                    addComment();
                    Navigator.of(context).pop();
                  },
                  child: Text("Save"),
                )
              ],
            ));
  }

  // add comment method
  void addComment() {
    // create a new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: widget.post.text,
      timestamp: DateTime.now(),
    );

    //   add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  //show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Post?"),
        content: Text("Are you sure you want to delete this post?"),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          //delete button
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.pop(context);
            },
            child: Text("Delete"),
          )
        ],
      ),
    );
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      child: Column(
        children: [
          //profile pic, name and delete button
          GestureDetector(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(uid: widget.post.userId))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //profile pic
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl,
                          errorWidget: (context, url, error) => const Icon(Icons.person),
                          imageBuilder: (context, imageProvider) => Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ))),
                        )
                      : const Icon(Icons.person),
                  SizedBox(width: 10),
                  //name
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  Spacer(),
                  //delete button
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showOptions,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          //post image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => SizedBox(height: 430, child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          //buttons: like, comment, timestamp
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 10),
            child: Row(
              children: [
                //like button
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: toggleLikePost,
                          child: Icon(
                            widget.post.likes.contains(currentUser!.uid) ? Iconsax.heart5 : Iconsax.heart,
                            color: widget.post.likes.contains(currentUser!.uid) ? Colors.red : Theme.of(context).colorScheme.primary,
                          )),
                      SizedBox(width: 5),
                      //like count
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                //comment button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Iconsax.send_2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 5),
                //comment count
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                //timestamp
                // Text(widget.post.timestamp.toString()),
                // Định dạng thời gian chỉ hiển thị ngày, giờ, phút
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(widget.post.timestamp),
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),

          //CAPTION
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
            child: Row(
              children: [
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Text(widget.post.text),
              ],
            ),
          ),
          //COMMENT SECTION
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              // Loaded
              if (state is PostsLoaded) {
                final post = state.posts.firstWhere((post) => (post.id == widget.post.id));

                if (post.comments.isNotEmpty) {
                  // how many comments to show
                  int showCommentsCount = post.comments.length;
                  //comment section
                  return ListView.builder(
                    itemCount: showCommentsCount,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];

                      //comment tile UI
                      return CommentTile(comment: comment);
                    },
                  );
                }
              }
              // Loading
              if (state is PostsLoading) {
                return Center(child: CircularProgressIndicator());
              }
              // Error
              else if (state is PostsError) {
                return Center(child: Text(state.message));
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
