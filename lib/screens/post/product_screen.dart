import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:secondhand/resources/auth_methods.dart';
import 'package:secondhand/resources/firestore_methods.dart';
import 'package:secondhand/screens/user/profile_page.dart';

import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/widgets/comment_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secondhand/utils/utils.dart';

import 'package:provider/provider.dart';
import 'package:secondhand/models/user.dart' as model;
import 'package:secondhand/providers/user_provider.dart';
import 'package:secondhand/widgets/marketky/review_tile.dart';
import 'package:uuid/uuid.dart';

class ProductDetailsView extends StatefulWidget {
  final snap;

  ProductDetailsView({super.key, required this.snap});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double _rating = 0.0;
  var userData = {};
  var anotherUserData = {};
  final FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _commentController = TextEditingController();

  bool addToLike() {
    return true;
  }

  Future<String> addToCollection(
      String description, String postId, String photoUrl, String title) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // String commentId = const Uuid().v1();

    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('collection')
        .doc(postId)
        .set({
      'uid': postId,
      // 'date': DateTime.now(),
      'title': title,
      // 'description': description,
      'postId': postId,
      'postUrl': photoUrl,
      'description': description,
    });
    return "ss";
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getAnotherUser();
  }

  deleteTheGoods() {
    db.collection("posts").doc(widget.snap['postId']).delete().then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }

  markAsSold() {
    db.collection("posts").doc(widget.snap['postId']).update({'sold': true});
  }

  showTheDialog(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Edit your goods',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
              color: AppColor.primary,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Delete the goods',
                  style: TextStyle(color: AppColor.primary),
                ),
                onPressed: () {
                  [deleteTheGoods(), Navigator.pop(context)];
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Mark as sold',
                  style: TextStyle(color: AppColor.primary),
                ),
                onPressed: () async {}),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColor.primary),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<String> addToPurchaseOrders(String soldID, String buyID,
      String photoUrl, String description, String title, String postID) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // String commentId = const Uuid().v1();

    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .doc(postID)
        .set({
      'agreed': false,
      'orderTime': DateTime.now(),
      'title': title,
      'description': description,
      'buyID': buyID,
      'soldID': soldID,
      'uid': postID,
      'postUrl': photoUrl,
    });

    _firestore
        .collection('users')
        .doc(soldID)
        .collection('orders')
        .doc(postID)
        .set({
      'agreed': false,
      'orderTime': DateTime.now(),
      'title': title,
      'description': description,
      'buyID': buyID,
      'soldID': soldID,
      'uid': postID,
      'postUrl': photoUrl,
    });
    return "ss";
  }

  Future<String> addToBrowesHistory(
      String postId, String photoUrl, String description, String title) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // String commentId = const Uuid().v1();

    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('browse')
        .doc(postId)
        .set({
      'uid': postId,
      'date': DateTime.now(),
      'Title': title,
      'description': description,
      'postId': postId,
      'postUrl': photoUrl,
    });
    return "ss";
  }

  var comments;

  // int length;
  getCommentIdList() async {
    comments = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments');
    // .snapshots();

    for (var y in comments) {}
  }

  User currentUser = FirebaseAuth.instance.currentUser!;

  getUser() async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    userData = user.data()!;
    setState(() {});
  }

  getAnotherUser() async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    anotherUserData = user.data()!;
    setState(() {});
  }

  void postComment(String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.snap['postId'],
        _commentController.text,
        FirebaseAuth.instance.currentUser!.uid,
        name,
        profilePic,
      );

      if (res == 'success') {
        _commentController.text = "";
      }
      showSnackBar(context, res);
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  void rate(String postID, double rating) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('ratings')
        .doc(postID)
        .set(
      {
        'ID': postID,
        'rating': rating,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snap == null) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          elevation: 0,
          leading: IconButton(
            onPressed: () => [
              Navigator.of(context).pop(),
              addToBrowesHistory(
                widget.snap['postId'],
                widget.snap['postUrl'],
                widget.snap['description'],
                //改成title
                widget.snap['title'],
              )
            ],
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            AuthMethods().isCurrentUser(widget.snap['uid'])
                ? IconButton(
                    onPressed: () {
                      showTheDialog(context);
                    },
                    icon: const Icon(
                      Icons.settings_ethernet_rounded,
                      color: Colors.white,
                    ),
                  )
                : Text("")
          ],
        ),
        body: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .35,
                  padding: const EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.snap['postUrl'].toString(),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  //child: Image.network(snap['photoUrl'].toString()),
                ),
              ),
              RatingBar.builder(
                initialRating: _rating,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  );
                },
                onRatingUpdate: (rating) {
                  rate(widget.snap['postId'], _rating);
                  setState(() {
                    _rating = rating;
                  });
                  // FirebaseFirestore.instance
                  //     .collection('users')
                  //     .doc(widget.snap['uid'])
                  //     .collection('ratings')
                  //     .doc(widget.snap['postId'])
                  //     .update({'value': rating});
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 400,
                      padding:
                          const EdgeInsets.only(top: 40, right: 14, left: 14),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.snap['title'].toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              ),
                              Text(
                                "¥ " + widget.snap['priceTag'].toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          //ignore_for_file: prefer_const_constructors
                          const SizedBox(height: 15),
                          Text(
                            widget.snap['description'].toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            widget.snap['likes'].length.toString() +
                                " people has like this product",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 15),

                          Container(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(widget.snap['postId'].toString())
                                  .collection('comments')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (ctx, index) => CommentCard(
                                    snap: snapshot.data!.docs[index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //reviews

              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              uid: anotherUserData['uid'],
                            ),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              NetworkImage(anotherUserData['photoUrl']),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        anotherUserData['username'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColor.primary),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _commentController,
                // autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Send a comment',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.border, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: AppColor.primarySoft,
                    filled: true,
                    //
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.send,
                      ),
                      onPressed: () {
                        postComment(userData['username'], userData['photoUrl']);
                      },
                    )),
              ),

              //Review
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTile(
                      initiallyExpanded: true,
                      childrenPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      tilePadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      title: Text(
                        'Reviews',
                        style: TextStyle(
                          color: AppColor.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                        ),
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.snap['postId'])
                              .collection('comments')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => ReviewTile(
                                comment: snapshot.data!.docs[index].data(),
                              ),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 16),
                              itemCount: snapshot.data!.docs.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 70,
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: widget.snap['likes'].contains(userData['uid'])
                    ? Icon(
                        Icons.star,
                        size: 30,
                        color: Colors.yellow,
                      )
                    : Icon(
                        Icons.star_border_outlined,
                        size: 30,
                        color: Colors.yellow,
                      ),
                onPressed: () {
                  [
                    FireStoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      userData['uid'],
                      widget.snap['likes'],
                    ),
                    addToCollection(
                      widget.snap['description'],
                      widget.snap['postId'],
                      widget.snap['postUrl'],
                      widget.snap['title'],
                    )
                  ];
                },
              ),
              SizedBox(width: 20),
              Expanded(
                child: InkWell(
                  onTap: () => FireStoreMethods().likePost(
                    widget.snap['postId'].toString(),
                    userData['uid'],
                    widget.snap['likes'],
                  ),
                  child: GestureDetector(
                    onTap: () => FireStoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      userData['uid'],
                      widget.snap['likes'],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: GestureDetector(
                        child: TextButton(
                          child: Text('Buy it'),
                          style: TextButton.styleFrom(
                            textStyle: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            addToPurchaseOrders(
                              widget.snap['uid'],
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.snap['postUrl'],
                              widget.snap['description'],
                              widget.snap['title'],
                              widget.snap['postId'],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
