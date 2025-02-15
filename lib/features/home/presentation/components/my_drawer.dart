import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_social_media/features/home/presentation/components/my_drawer_tile.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:flutter_social_media/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_social_media/features/search/presentation/pages/search_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(children: [
            // logo (header)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Icon(
                Icons.person,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            // Divider line
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            //Home tile
            MyDrawerTile(
              title: "HOME",
              icon: Icons.home,
              onTap: () => Navigator.of(context).pop(),
            ),
            //Profile tile
            MyDrawerTile(
                title: "PROFILE",
                icon: Icons.person,
                onTap: () {
                  Navigator.of(context).pop();

                  //get current user id
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        uid: uid,
                      ),
                    ),
                  );
                }),
            //Search tile
            MyDrawerTile(
              title: "SEARCH",
              icon: Icons.search,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              ),
            ),
            //Settings tile
            MyDrawerTile(title: "SETTINGS", icon: Icons.settings, onTap: () {}),
            Spacer(),
            //Logout tile
            MyDrawerTile(
              title: "LOGOUT",
              icon: Icons.logout,
              onTap: () => context.read<AuthCubit>().logout(),
            ),
          ]),
        ),
      ),
    );
  }
}
