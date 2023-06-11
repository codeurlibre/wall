// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:the_wall_app/pages/login_page.dart';

import '../pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // * Initially, show the login
  bool showLoginPage = true;

  // * Toggle betwen login or register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
      print(showLoginPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
