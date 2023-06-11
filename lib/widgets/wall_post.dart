// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  // final String time;
  const WallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // * User
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Is like
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // * Toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // * Access the document is Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      // if the post is now liked, add the user's email to the 'likes' field
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // if the post is now unliked, remove the user's email from the 'likes'
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Column(
            children: [
              // * Like button
              LikeButton(isLiked: isLiked, onTap: toggleLike),

              const SizedBox(
                height: 5,
              ),

              // * Like count
              Text(
                widget.likes.length.toString(),
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          // * Profil pic
          Container(
            padding: const EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 15,
          ),

          // * Message and user email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.message,
                  // maxLines: 1,
                  // softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
