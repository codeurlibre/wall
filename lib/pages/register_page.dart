// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/button.dart';
import '../widgets/textfield.dart';
// import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // * Text editting Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool inLoginProcess = false;

  // ? Sign up user method
  void signUp() async {
    // * Show loading circle
    setState(() {
      inLoginProcess = true;
    });

    // * Make sure passwords match
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      // Show error to user
      setState(() {
        inLoginProcess = false;
      });
      displayMessage("Passwords dont'match!");
      return;
    }

    // * Try creating user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      // * After creating the user, create a new document in cloud firestore called Users
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        /* Initial username */
        "username": emailController.text.split("@")[0],
        /* Initial bio */
        "bio": "Empty bio.."
        // Add any additional fields neeted
      });

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
                  const Text("Lets create an account for you"),
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
                  //? Confirm password textfield
                  MyTextField(
                      controller: confirmPasswordController,
                      type: TextInputType.text,
                      hintText: "Password",
                      obscureText: true),
                  const SizedBox(
                    height: 25,
                  ),
                  //* Sign In button
                  inLoginProcess
                      ? const Center(child: CircularProgressIndicator())
                      : MyButton(onTap: signUp, text: "Register"),
                  const SizedBox(
                    height: 25,
                  ),

                  //* Go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Are you a member? ",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "login now",
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

// () => Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LoginPage(),
//                             ),
//                             (route) => false)