import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondhand/screens/user/profile_page.dart';
import 'package:secondhand/utils/colors.dart';
import 'package:secondhand/utils/utils.dart';

class followerScreen extends StatefulWidget {
  final List<DocumentSnapshot<Map<String, dynamic>>> followersSnapList;
  final List<DocumentSnapshot<Map<String, dynamic>>> followingSnapList;
  final int whichScreen;

  const followerScreen(
      {Key? key,
      required this.followersSnapList,
      required this.followingSnapList,
      required this.whichScreen})
      : super(key: key);

  @override
  State<followerScreen> createState() => _followerScreenState();
}

class _followerScreenState extends State<followerScreen> {
  List<String> photoUrl = [];
  List<String> username = [];
  List<String> uid = [];
  List<DocumentSnapshot<Map<String, dynamic>>> Screen = [];
  @override
  Widget build(BuildContext context) {
    if (widget.whichScreen == 0) {
      Screen = widget.followersSnapList;
    } else if (widget.whichScreen == 1) {
      Screen = widget.followingSnapList;
    }

    for (var userSnap in Screen) {
      photoUrl.add(userSnap['photoUrl']);
      username.add(userSnap['username']);
      uid.add(userSnap['uid']);
    }
    int itemCount = photoUrl.length;
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  uid: uid[index],
                ),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  photoUrl[index],
                ),
                radius: 16,
              ),
              title: Text(
                username[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
