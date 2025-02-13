import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/data/firebase_auth_repository.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_states.dart';
import 'package:flutter_social_media/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter_social_media/features/home/presentation/pages/home_page.dart';
import 'package:flutter_social_media/features/profile/data/firebase_profile_repository.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:flutter_social_media/features/storage/data/firebase_storage_repository.dart';
import 'package:flutter_social_media/themes/light_mode.dart';

/*
  - App - Root level
  - Repository - for the database
    + firebase
  - Bloc Providers: for state management
    + auth
    + profile
    + home
    + search
    + theme
  - Check auth state
    + unauthenticated -> auth page(login/register)
    + authenticated -> home page
* */

class MyApp extends StatelessWidget {
  // auth repo
  final firebaseAuthRepository = FirebaseAuthRepository();

  // profile repo
  final firebaseProfileRepository = FirebaseProfileRepository();
  // storage repo
  final firebaseStorageRepository = FirebaseStorageRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: lightMode,
    //   home: const AuthPage(),
    // );
    //provide cubit to app
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: firebaseAuthRepository)..checkAuthStatus(),
        ),
        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepository: firebaseProfileRepository,
            storageRepository: firebaseStorageRepository,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
            if (authState is Unauthenticated) {
              return const AuthPage();
            }
            if (authState is Authenticated) {
              return const HomePage();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          //listen to auth error
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
    // BlocProvider(
    //   create: (context) => AuthCubit(authRepo: authRepo)..checkAuthStatus(),
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     theme: lightMode,
    //     home: BlocConsumer<AuthCubit, AuthState>(
    //       builder: (context, authState) {
    //         print(authState);
    //         if (authState is Unauthenticated) {
    //           return const AuthPage();
    //         }
    //         if (authState is Authenticated) {
    //           return const HomePage();
    //         } else {
    //           return const Center(child: CircularProgressIndicator());
    //         }
    //       },
    //       //listen to auth error
    //       listener: (context, state) {
    //         if (state is AuthError) {
    //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    //         }
    //       },
    //     ),
    //   ),
    // );
  }
}
