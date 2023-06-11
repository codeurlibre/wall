import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType type;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText,
      textAlign: TextAlign.center,
      cursorColor: Colors.grey,
      // style: const TextStyle(color: Colors.black26),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        // suffixIcon: GestureDetector(
        //   onTap: () {
        //     setState(() {
        //       obscureText = !obscureText;
        //     });
        //   },
        //   child: obscureText
        //       ? const Icon(Icons.visibility_off_outlined)
        //       : const Icon(Icons.visibility_outlined),
        // ),
        hintStyle:
            TextStyle(color: Colors.grey[500], overflow: TextOverflow.ellipsis),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.white)),

        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}
