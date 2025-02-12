import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_social_media/features/home/presentation/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      //DRAWER
      drawer: const MyDrawer(),
    );
  }
}
