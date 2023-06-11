import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/drawer.dart';
import '../widgets/textfield.dart';
import '../widgets/wall_post.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ? Then controller
  TextEditingController textController = TextEditingController();

  // ? User
  final currentUser = FirebaseAuth.instance.currentUser;

  // ? Sign Out user method
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // ? Post messsage method
  // CollectionReference users = FirebaseFirestore.instance.collection('User Posts');
  void postMessage() {
    // * Only post if there is something in the textfield
    if (textController.text.trim().isNotEmpty) {
      // * Store in Firebase
      FirebaseFirestore.instance.collection('User Posts').add({
        "UserEmail": currentUser!.email,
        "Message": textController.text.trim(),
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }
    // * Clear the textfield
    setState(() {
      // textController.text = "";
      textController.clear();
    });
  }

  // * Navigate to profile page
  void goToProfilePage() {
    //  Pop menu drawer
    Navigator.pop(context);
    // Go to profile page
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: MyDrawer(
        onProfilTap: goToProfilePage,
        onSignOut: signOut,
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "The Wall",
          // style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // * The wall
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .orderBy("TimeStamp", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    // * Get the message
                    final post = snapshot.data!.docs[index];
                    return WallPost(
                      message: post["Message"],
                      user: post["UserEmail"],
                      postId: post.id,
                      likes: List<String>.from(post["Likes"] ?? []),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error ${snapshot.hasError}"),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),

          // * Post message
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                // * TextField
                Expanded(
                    child: MyTextField(
                        controller: textController,
                        hintText: "Whrite something on the wall",
                        obscureText: false,
                        type: TextInputType.text)),
                const SizedBox(
                  width: 10,
                ),

                // * Post button
                GestureDetector(
                  onTap: postMessage,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Icon(Icons.arrow_circle_up_outlined),
                  ),
                )
              ],
            ),
          ),

          // * Logged in as
          Text("Logged in as ${currentUser!.email}"),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
