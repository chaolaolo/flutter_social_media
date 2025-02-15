import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/profile/presentation/components/user_tile.dart';
import 'package:flutter_social_media/features/search/presentation/cubits/search_cubit.dart';
import 'package:flutter_social_media/features/search/presentation/cubits/search_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  //on search method
  void onSearchChange() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChange);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search users...",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),

        //search result
        body: BlocBuilder<SearchCubit, SearchStates>(
          builder: (context, state) {
            // loaded
            if (state is SearchLoaded) {
              //no users
              if (state.users.isEmpty) {
                return Center(child: Text("No users found"));
              }
              //users
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return UserTile(user: user!);
                },
              );
            } else if (state is SearchLoading) {
              // loading
              return Center(child: CircularProgressIndicator());
            } else if (state is SearchError) {
              // error
              return Center(child: Text(state.message));
            }
            // default
            return const Center(child: Text("Search for users"));
          },
        ));
  }
}
