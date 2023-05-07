import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/screens/general/chatPage.dart';

class ProfileWidget extends StatefulWidget {
  final String imagePath;
  final onPressed;
  final String uid;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onPressed,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  void initState() {
    super.initState();
    getData();
  }

  var userData = {};
  var userDataAnother = {};
  @override
  Widget build(BuildContext context) {
    String ID = FirebaseAuth.instance.currentUser!.uid;
    final color = Theme.of(context).colorScheme.primary;
    bool current = (ID == widget.uid);
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: current ? buildEditIcon(color) : buildChatIcon(color),
          ),
        ],
      ),
    );
  }

  getData() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userData = userSnap.data()!;

    var userSnapA = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    userDataAnother = userSnapA.data()!;
  }

  Widget buildImage() {
    final image = NetworkImage(widget.imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      ),
    );
  }

  Widget buildChatIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: InkWell(
            child: Icon(
              Icons.chat,
              color: Colors.white,
              size: 20,
            ),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MessageDetailPage(
                    currentUserSnap: userData,
                    anotherUserSnap: userDataAnother,
                  ),
                ),
              )
            },
          ),
        ),
      );

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: InkWell(
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
              onTap: widget.onPressed),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
