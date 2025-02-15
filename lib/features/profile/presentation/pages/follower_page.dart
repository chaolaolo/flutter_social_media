import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/profile/presentation/components/user_tile.dart';
import 'package:flutter_social_media/features/profile/presentation/cubits/profile_cubit.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    //Tab Controller
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              dividerColor: Colors.transparent,
              labelColor:Theme.of(context).colorScheme.inversePrimary,
              unselectedLabelColor:Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(text: "Followers"),
                Tab(text: "Following"),
              ]),
        ),

        //body
        body: TabBarView(children: [
          _buildUserList(followers, "No followers", context),
          _buildUserList(following, "No following", context),
        ]),
      ),
    );
  }

  // build user list, given a list of profile uids
  Widget _buildUserList(List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(
      child: Text(emptyMessage),
    )
        : ListView.builder(
      itemCount: uids.length,
      itemBuilder: (BuildContext context, int index) {
        // get each uid
        final uid = uids[index];
        return FutureBuilder(
          future: context.read<ProfileCubit>().getUserProfile(uid),
          builder: (context, snapshot) {
            //user loaded
            if (snapshot.hasData) {
              final user = snapshot.data!;
              return UserTile(user: user);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              //user loading
              return ListTile(title: Text("Loading.."));
            } else {
              //user not found
              return ListTile(title: Text("User not found!"));
            }
          },
        );
      },
    );
  }
}
