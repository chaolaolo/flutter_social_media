import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/features/auth/presentation/components/my_button.dart';
import 'package:flutter_social_media/features/auth/presentation/components/my_text_field.dart';
import 'package:flutter_social_media/features/auth/presentation/cubits/auth_cubits.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;

  const LoginPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Text Editing Controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //login method
  void login() {
    //prepare email & password
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    //call login method from cubit
    final authCubit = context.read<AuthCubit>();
    //ensure that email and password are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter both email and password!")));
    }
  }

  //
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //BODY
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 50),
                //welcome back msg
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 25),
                // email text field
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                SizedBox(height: 10),
                // password text field
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                //login button
                SizedBox(height: 25),
                MyButton(
                  onTap: login,
                  text: "Login",
                ),
                SizedBox(height: 25),
                //forgot password
                //not a member? register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Register now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
