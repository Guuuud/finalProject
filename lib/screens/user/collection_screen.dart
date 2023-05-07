import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/resources/auth_methods.dart';
import 'package:secondhand/resources/firestore_methods.dart';
import 'package:secondhand/screens/user/follower_screen.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/utils/colors.dart';
import 'package:secondhand/utils/utils.dart';
import 'package:secondhand/widgets/follow_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:secondhand/widgets/marketky/carttile.dart';

List<String> likedPost = [];
List<String> likedPostTitle = [];

class CollectionScreen extends StatefulWidget {
  CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var postSnap = await FirebaseFirestore.instance.collection('posts').get();

    try {
      for (var i in postSnap.docs) {
        for (String likeId in i['likes']) {
          if (likeId == FirebaseAuth.instance.currentUser!.uid.toString()) {
            setState(() {
              likedPost.add(i['postUrl']);
              //后续改成Title
              likedPostTitle.add(i['title']);
            });
          }
        }
      }
    } catch (e) {
      print(e.toString() + "++++++");
    }
  }

  @override
  Widget build(BuildContext context) {
    // var likedPosts = getData();
    getData();
    print(likedPost);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'Your Cart',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text("10" + " items",
                style: TextStyle(
                    fontSize: 10, color: Colors.black.withOpacity(0.7))),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.primary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColor.primarySoft,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('collection')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return

                    //  InkWell(
                    //   child: ListTile(
                    //     leading: CircleAvatar(
                    //       backgroundImage:
                    //           NetworkImage(snapshot.data!.docs[index]["postUrl"]),
                    //       radius: 16,
                    //     ),
                    //     title: Text(
                    //       snapshot.data!.docs[index]["title"],
                    //       style: TextStyle(color: Colors.amber),
                    //     ),
                    //   ),
                    // );
                    CartTile(snapdata: snapshot.data!.docs[index]);
              },
            );
          }),
    );
  }
}
