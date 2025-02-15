import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/domain/entities/app_user.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_social_media/features/post/domain/entities/comment.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  //current user
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //get current user method
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  //show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete comment?"),
        content: Text("Are you sure you want to delete this comment?"),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          //delete button
          TextButton(
            onPressed: () {
              context.read<PostCubit>().deleteComment(widget.comment.postId, widget.comment.id);
              Navigator.pop(context);
            },
            child: Text("Delete"),
          )
        ],
      ),
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // name
          Text(
            widget.comment.userName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 10,
          ),
          // comment text
          Text(widget.comment.text),
          Spacer(),
          //delete button
          if (isOwnPost)
            GestureDetector(
              onTap: showOptions,
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
        ],
      ),
    );
  }
}
