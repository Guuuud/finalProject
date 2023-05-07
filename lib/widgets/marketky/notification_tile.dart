import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/models/user.dart' as model;
import 'package:secondhand/utils/app_color.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatefulWidget {
  final snap;

  const NotificationTile({super.key, required this.snap});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  User currentUser = FirebaseAuth.instance.currentUser!;
  confirmOrder(BuildContext parentContext) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Are you sure to agree this order?',
                style: TextStyle(color: AppColor.primary),
              ),
              children: <Widget>[
                SimpleDialogOption(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: AppColor.primary),
                    ),
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .collection('orders')
                          .doc(widget.snap['uid'])
                          .update({
                        "agreed": true,
                      });
                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.snap['uid'])
                          .update({
                        "sold": true,
                      });
                      var temp = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .collection('orders')
                          .doc(widget.snap['uid'])
                          .get();
                      var temp1 = temp.data()!;

                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(temp1['buyID'])
                          .collection('orders')
                          .doc(widget.snap['uid'])
                          .update({
                        "agreed": true,
                      });
                    }),
                SimpleDialogOption(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'No',
                      style: TextStyle(color: AppColor.primary),
                    ),
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .collection('orders')
                          .doc(widget.snap['uid'])
                          .delete()
                          .then(
                            (doc) => print("Document deleted"),
                            onError: (e) => print("Error updating document $e"),
                          );

                      var temp = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .collection('orders')
                          .doc(widget.snap['uid'])
                          .get();
                      var temp1 = temp.data()!;

                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(temp1['buyID'])
                          .collection('orders')
                          .doc(widget.snap['uid'])
                          .delete()
                          .then(
                            (doc) => print("Document deleted"),
                            onError: (e) => print("Error updating document $e"),
                          );
                    }),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColor.border,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(widget.snap['postUrl']),
                    fit: BoxFit.cover),
              ),
              margin: EdgeInsets.only(right: 16),
            ),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.snap['title'],
                    style: TextStyle(
                        color: AppColor.secondary,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w500),
                  ),
                  // Description
                  Container(
                    margin: EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                      widget.snap['description'],
                      style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          fontSize: 12),
                    ),
                  ),
                  // Datetime
                  Row(
                    children: [
                      !widget.snap['agreed']
                          ? IconButton(
                              icon: Icon(Icons.done_all),
                              onPressed: () {
                                confirmOrder(context);
                              },
                              color: AppColor.primary,
                            )
                          : Text(""),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          // DateFormat('MM-dd').format(snapdata['date'].toDate()),
                          DateFormat('MM-dd')
                              .format(widget.snap['orderTime'].toDate()),
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.7),
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
