import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
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
  //mobile image pick
  PlatformFile? imagePickedFile;

  //web image pick
  Uint8List? webImage;

  //bio text Controller
  final bioController = TextEditingController();

  //pick image method
  void pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: kIsWeb);
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // save method
  void uploadProfile() {
    //profile cubit
    final profileCubit = context.read<ProfileCubit>();

    //prepare images
    final String uid = widget.user.uid;
    final String? newBio = bioController.text.isNotEmpty ? bioController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    //only update profile if there is something to update
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateUserProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    } else {
      Navigator.pop(context);
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

  Widget buildEditPage() {
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
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              clipBehavior: Clip.hardEdge,
              child:
                  //display selected image for mobile
                  (!kIsWeb && imagePickedFile != null)
                      ? Image.file(
                          File(imagePickedFile!.path!),
                          fit: BoxFit.cover,
                        )
                      //display selected image for web
                      : (kIsWeb && webImage != null)
                          ? Image.memory(
                              webImage!,
                              fit: BoxFit.cover,
                            )
                          //no image selected=> display existing profile image
                          : CachedNetworkImage(
                              imageUrl: widget.user.profileImageUrl,
                              //loading..
                              placeholder: (context, url) => CircularProgressIndicator(),
                              //error
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 70,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              //loaded
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                              ),
                            ),
            ),
          ),
          SizedBox(height: 25),
          //pick image button
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ),
          ),
          SizedBox(height: 25),

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
