import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/domain/entities/app_user.dart';
import 'package:flutter_social_media/features/auth/presentation/components/my_text_field.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_social_media/features/post/domain/entities/post.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_cubit.dart';
import 'package:flutter_social_media/features/post/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  //mobile image pick
  PlatformFile? imagePickedFile;

  //web image pick
  Uint8List? webImage;

  // text controller
  final textController = TextEditingController();

  //current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //get current user method
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  //select image method
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

  //create and upload post method
  void uploadPost() {
    //check if both image and caption are provided
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Both image and caption are required!")));
      return;
    }
    //create a new post object
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(), likes: [], comments: [],
    );

    //post cubit
    final postCubit = context.read<PostCubit>();
    if (kIsWeb) {
      //web upload
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    } else {
      //mobile upload
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        //loading ord uploading
        if (state is PostsLoading || state is PostUploading) {
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }
        //build upload page
        return buildUploadPage();
      },
      //go to previous page on success
      listener: (context, state) {
        if(state is PostsLoaded){
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      //APPBAR
      appBar: AppBar(
        title: Text("Create Post"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //upload button
          IconButton(
            onPressed: uploadPost,
            icon: Icon(Icons.check),
          )
        ],
      ),

      //BODY
      body: Center(
        child: Column(children: [
          //image preview for web
          if (kIsWeb && webImage != null) Image.memory(webImage!),
          //image preview for mobile
          if (!kIsWeb && imagePickedFile != null) Image.file(File(imagePickedFile!.path!)),
          //pick image button
          MaterialButton(
            onPressed: pickImage,
            color: Colors.blueGrey,
            child: Text("Pick Image"),
          ),

          //caption text box
          MyTextField(
            controller: textController,
            hintText: "Caption",
            obscureText: false,
          ),
        ]),
      ),
    );
  }
}
