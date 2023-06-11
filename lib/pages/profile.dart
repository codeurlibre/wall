// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // * User
  final currentUser = FirebaseAuth.instance.currentUser!;

  // * All users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  // * New value
  String newValue = "";

  // * Edit field
  Future<void> editField(String field) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          onChanged: (value) {
            newValue = value;
            // setState(() {
            //   newValue = "";
            // });
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Enter new  $field",
              hintStyle: const TextStyle(color: Colors.grey)),
        ),
        actions: [
          // * Cancel button
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              )),

          // * Save button
          TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );

    // * Update in firestore
    if (newValue.trim().isNotEmpty) {
      // only update if there is something in the textfield
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            // * Get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // * Profil pic
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // * User email
                  Text(
                    "${currentUser.email}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 18),
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  // * User detail
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "My Details",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                  // * Username
                  MyTextBox(
                    text: userData["username"],
                    sectionName: "Username",
                    onPressed: () => editField("username"),
                  ),

                  // * Bio
                  MyTextBox(
                    text: userData["bio"],
                    sectionName: "Bio",
                    onPressed: () => editField("bio"),
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  // * User posts
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                    ),
                    child: Text(
                      "My Posts",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.hasError}"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
