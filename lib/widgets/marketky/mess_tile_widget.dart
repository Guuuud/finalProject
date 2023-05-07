import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/screens/general/chatPage.dart';

import 'package:secondhand/utils/app_color.dart';

class MessageTileWidget extends StatefulWidget {
  final snap;

  MessageTileWidget({super.key, required this.snap});

  @override
  State<MessageTileWidget> createState() => _MessageTileWidgetState();
}

class _MessageTileWidgetState extends State<MessageTileWidget> {
  var userDataAnother = {};

  var userData = {};
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var userSnapAnother = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['chatterID'])
        .get();
    userDataAnother = userSnapAnother.data()!;

    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userData = userSnapAnother.data()!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColor.primarySoft, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(widget.snap["imageUrl"])),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.snap['username'],
                      style: TextStyle(
                          color: AppColor.secondary,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 5),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor.border,
            ),
          ],
        ),
      ),
    );
  }
}
