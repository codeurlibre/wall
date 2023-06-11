// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/button.dart';
import '../widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //  Text editting Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // In login process
  bool inLoginProcess = false;

  // ? Sign In user method

  void signIn() async {
    // * Show loading circle
    setState(() {
      inLoginProcess = true;
    });

    // * Try login user
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      // * Pop loading circle
    } on FirebaseException catch (e) {
      // * Pop loading circle
      setState(() {
        inLoginProcess = false;
      });
      // * Display error message
      displayMessage(e.code);
      print(e.code);
    }
  }

  // ? Display a dialog message
  void displayMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //* Logo
                  const Icon(
                    Icons.lock,
                    size: 80,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //? Welcome  back message
                  const Text("Welcome back, you've been missed!"),
                  const SizedBox(
                    height: 25,
                  ),

                  //? Email textfield
                  MyTextField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      hintText: "Email",
                      obscureText: false),

                  const SizedBox(
                    height: 20,
                  ),

                  //? Password textfield
                  MyTextField(
                      controller: passwordController,
                      type: TextInputType.text,
                      hintText: "Password",
                      obscureText: true),
                  const SizedBox(
                    height: 25,
                  ),
                  inLoginProcess
                      ? const Center(child: CircularProgressIndicator())
                      : MyButton(onTap: signIn, text: "Login"),
                  const SizedBox(
                    height: 25,
                  ),

                  //* Go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member? ",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "register now",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
