import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/home/presentation/components/my_drawer.dart';
import 'package:flutter_social_media/features/post/presentation/components/post_tile.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_cubit.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_states.dart';
import 'package:flutter_social_media/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //post cubit
  late final postCubit = context.read<PostCubit>();

  //on startup
  @override
  void initState() {
    super.initState();

    //fetchAllPosts
    fetchAllPosts();
  }

  //Fetch All Posts method
  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  //delete a post method
  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //upload new post button
          Container(
            margin: EdgeInsets.only(right: 20),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadPostPage(),
                ),
              ),
              icon: Icon(
                Icons.add,
              ),
            ),
          )
        ],
      ),
      //DRAWER
      drawer: const MyDrawer(),

      //BODY
      body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
        //lading..
        if (state is PostsLoading || state is PostUploading) {
          return Center(child: CircularProgressIndicator());
        }
        //loaded
        else if (state is PostsLoaded) {
          final allPosts = state.posts;
          if (allPosts.isEmpty) {
            return const Center(child: Text("No posts available"));
          }
          return ListView.builder(
            itemCount: allPosts.length,
            itemBuilder: (context, index) {
              //get individual post
              final post = allPosts[index];
              //image
              return PostTile(
                post: post,
                onDeletePressed: () => deletePost(post.id),
              );
            },
          );
        }
        // error
        else if (state is PostsError) {
          return Center(child: Text(state.message));
        } else {
          return SizedBox();
        }
      }),
    );
  }
}
