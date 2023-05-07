import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/resources/auth_methods.dart';
import 'package:secondhand/screens/auth/login_screen.dart';
import 'package:secondhand/screens/general/chatgroup.dart';
import 'package:secondhand/utils/app_color.dart';

class CustomIconButtonWidget extends StatelessWidget {
  Future<QuerySnapshot<Map<String, dynamic>>> getRandomPosts() async {
    final QuerySnapshot<Map<String, dynamic>> postSnap =
        await FirebaseFirestore.instance.collection('posts').get();

    final int totalPosts = postSnap.docs.length;

    final List<int> randomIndices =
        List.generate(6, (index) => Random().nextInt(totalPosts));

    final List<String> postIds = [];
    for (int i = 0; i < randomIndices.length; i++) {
      postIds.add(postSnap.docs[randomIndices[i]].id);
    }

    final QuerySnapshot<Map<String, dynamic>> randomPostSnap =
        await FirebaseFirestore.instance
            .collection('posts')
            .where(FieldPath.documentId, whereIn: postIds)
            .get();

    return randomPostSnap;
  }

  Future<void> addToRecommendations(String userId) async {
    // Delete the existing recommendation subcollection
    QuerySnapshot existingRecommendations = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('recommendation')
        .get();
    List<Future<void>> deleteOperations = [];
    for (DocumentSnapshot doc in existingRecommendations.docs) {
      deleteOperations.add(doc.reference.delete());
    }
    await Future.wait(deleteOperations);
    // Get a reference to the user document
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Check if the recommendation subcollection exists
    bool exists = await userRef
        .collection('recommendation')
        .limit(1)
        .get()
        .then((value) => value.docs.isNotEmpty);

    // Create the recommendation subcollection if it doesn't exist
    if (!exists) {
      await userRef.collection('recommendation').add({});
    }
    deleteOperations = [];
    QuerySnapshot existingRecommendationss = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('recommendation')
        .get();
    for (DocumentSnapshot doc in existingRecommendationss.docs) {
      deleteOperations.add(doc.reference.delete());
    }
    await Future.wait(deleteOperations);
    // Get a reference to the recommendation subcollection
    CollectionReference recRef = userRef.collection('recommendation');

    // Retrieve 10 random posts from the posts collection
    QuerySnapshot postSnap = await getRandomPosts();

    List<DocumentSnapshot> posts = postSnap.docs;
    // const recRef =  FirebaseFirestore.instance.collection(user/${userId}/recommendation);
    // Add each post to the recommendation subcollection
    for (var post in posts) {
      var postData = post.data();

      await recRef.add(post.data());
      // await userRef.collection('recommendation').add(postData);
    }
  }

  final Widget icon;
  final int value;
  final EdgeInsetsGeometry margin;
  final Function onTap;
  final int type;

  CustomIconButtonWidget({
    required this.icon,
    required this.value,
    required this.onTap,
    required this.margin,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (type == 1) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => chatGroup(),
            ),
          );
        },
        child: Container(
          width: 50,
          height: 50,
          margin: margin,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: icon,
              ),
              (value != 0)
                  ? Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColor.accent,
                      ),
                      child: Text(
                        '$value',
                        style: TextStyle(
                            color: AppColor.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          addToRecommendations(FirebaseAuth.instance.currentUser!.uid);
        },
        child: Container(
          width: 50,
          height: 50,
          margin: margin,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: icon,
              ),
              (value != 0)
                  ? Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColor.accent,
                      ),
                      child: Text(
                        '$value',
                        style: TextStyle(
                            color: AppColor.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      );
    }
  }
}
