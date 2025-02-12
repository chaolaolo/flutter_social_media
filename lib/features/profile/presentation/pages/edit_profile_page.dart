import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/presentation/components/my_text_field.dart';
import 'package:flutter_social_media/features/profile/domain/entities/profile_user.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioController = TextEditingController();

  // save method
  void uploadProfile() {
    //profile cubit
    final profileCubit = context.read<ProfileCubit>();
    if (bioController.text.isNotEmpty) {
      profileCubit.updateUserProfile(
        uid: widget.user.uid,
        newBio: bioController.text,
      );
    }
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      //profile loading
      if (state is ProfileLoading) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("Uploading.."),
              ],
            ),
          ),
        );
      } else {
        return buildEditPage();
      }
    }, listener: (context, state) {
      if (state is ProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //save button
          IconButton(
            onPressed: uploadProfile,
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: Column(
        children: [
          //profile image

          //bio
          Text("Bio"),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioController,
              hintText: widget.user.bio,
              obscureText: false,
            ),
          )
        ],
      ),
    );
  }
}
