import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/domain/entities/app_user.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_social_media/features/post/presentation/components/post_tile.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_cubit.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_states.dart';
import 'package:flutter_social_media/features/profile/presentation/components/bio_box.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_states.dart';
import 'package:flutter_social_media/features/profile/presentation/pages/edit_profile_page.dart';

import '../cubits/profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //current user
  late AppUser? currentUser = authCubit.currentUser;

  //posts
  int postCount = 0;

  //on startup
  @override
  void initState() {
    super.initState();
    profileCubit.fetchUserProfile(widget.uid);
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //loaded
        if (state is ProfileLoaded) {
          //get loaded user
          final user = state.profileUser;
          return Scaffold(
            //APPBAR
            appBar: AppBar(
              title: Text(user.name),
              centerTitle: true,
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: user,),
                    ),
                  ),
                  icon: Icon(Icons.settings),
                ),
              ],
            ),

            //BODY
            body: ListView(
              children: [
                //email
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                //profile image
                SizedBox(height: 25),
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  //loading..
                  placeholder: (context, url) => CircularProgressIndicator(),
                  //error
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    size: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  //loaded
                  imageBuilder: (context, imageProvider) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                //bio box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                BioBox(text: user.bio),
                SizedBox(height: 25),
                //posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        "Your Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                //list of posts from this user
                BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                  // loaded
                  if (state is PostsLoaded) {
                    //filter posts by user id
                    final userPosts = state.posts.where((post) => post.userId == widget.uid).toList();

                    postCount = userPosts.length;

                    return ListView.builder(
                      itemCount: postCount,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final post = userPosts[index];
                        return PostTile(
                          post: post,
                          onDeletePressed: () {
                            context.read<PostCubit>().deletePost(post.id);
                          },
                        );
                      },
                    );
                  } else if (state is PostsLoading) {
                    // posts loading
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    //error
                    return Center(
                      child: Text("No posts found.."),
                    );
                  }
                }),
              ],
            ),
          );
        } else if (state is ProfileLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProfileError) {
          return Center(
            child: Text("Error: ${state.errorMessage}"),
          );
        } else {
          return Center(
            child: Text("No profile found.."),
          );
        }
      },
    );
  }
}
