import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/models/user.dart' as model;
import 'package:secondhand/providers/user_provider.dart';
import 'package:secondhand/resources/firestore_methods.dart';
import 'package:secondhand/screens/func/comments_screen.dart';
import 'package:secondhand/utils/colors.dart';
import 'package:secondhand/utils/global_variable.dart';
import 'package:secondhand/utils/utils.dart';
import 'package:secondhand/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewPostCard extends StatefulWidget {
  final snap;
  const NewPostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<NewPostCard> createState() => _NewPostCardState();
}

class _NewPostCardState extends State<NewPostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    int index = 10;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Color(0xffEEEEEE),
                offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                blurRadius: 4, //阴影模糊程度
                spreadRadius: 1 //阴影扩散程度
                ),
          ]),
      child: Column(
        children: [
          index % 2 == 0
              ? AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.snap['postUrl'].toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                  ),
                )
              : Container(),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.snap['profImage'].toString(),
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50)),
                ),
                SizedBox(width: 10),
                Text('用户昵称', maxLines: 1, overflow: TextOverflow.ellipsis)
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.snap['title'].toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                color: Color(0xff333333),
              ),
            ),
          ),
          index % 2 != 0 ? SizedBox(height: 10) : SizedBox(),
          index % 2 != 0
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.snap['description'].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: TextStyle(fontSize: 24, color: Colors.black26),
                  ),
                )
              : Container(),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
