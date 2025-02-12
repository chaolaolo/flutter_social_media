import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/domain/entities/app_user.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_cubits.dart';
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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  //email
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  //profile image
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(25),
                    height: 120,
                    width: 120,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  //bio box
                  Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  BioBox(text: user.bio),
                  SizedBox(height: 25),
                  //posts
                  Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileLoading) {
          return Center(
            child: CircularProgressIndicator(),
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
