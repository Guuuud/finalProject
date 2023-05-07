import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand/resources/storage_methods.dart';
import 'package:secondhand/screens/post/product_screen.dart';
import 'package:secondhand/screens/user/edit_profile_new.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:secondhand/utils/user_preferences.dart';
import 'package:secondhand/widgets/appbar_widget.dart';
import 'package:secondhand/widgets/button_widget.dart';
import 'package:secondhand/widgets/numbers_widget.dart';
import 'package:secondhand/widgets/profile_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

import 'package:secondhand/screens/user/follower_screen.dart';
import 'package:secondhand/screens/user/edit_profile.dart';
import 'package:secondhand/utils/colors.dart';
import 'package:secondhand/utils/utils.dart';
import 'package:secondhand/widgets/follow_button.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};

  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  Uint8List? _file;
  List<DocumentSnapshot<Map<String, dynamic>>> followersSnapList = [];
  List<DocumentSnapshot<Map<String, dynamic>>> followingSnapList = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  editUser(String photo) {
    User currentUser = FirebaseAuth.instance.currentUser!;
    // var userData =
    //     FirebaseFirestore.instance.collection('user').doc(currentUser.uid);
    print(currentUser.uid);
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      "photoUrl": photo,
    });
    showSnackBar(
      context,
      'Success',
    );
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Edit your avatar',
            style: TextStyle(color: AppColor.primary),
          ),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Take a photo',
                  style: TextStyle(color: AppColor.primary),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: AppColor.primary),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // final List<Uint8List>? selectedImages =
                  //     await imagePicker.pickMultiImage();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  String photoUrl = await StorageMethods()
                      .uploadImageToStorage('profilePics', file, false);
                  editUser(photoUrl);
                  setState(() {
                    _file = file;
                  });
                }),
          ],
        );
      },
    );
  }

  getData() async {
    // final DocumentReference userDocRef =
    //     FirebaseFirestore.instance.collection("users").doc(widget.uid);

    // final CollectionReference ratingsRef = userDocRef.collection('rass');
    // final CollectionReference itemsRef =
    //     FirebaseFirestore.instance.collection('posts');

    // final QuerySnapshot itemsSnapshot = await itemsRef.get();
    // final List<String> itemIds =
    //     itemsSnapshot.docs.map((doc) => doc.id).toList();

    // for (final itemId in itemIds) {
    //   await ratingsRef.doc(itemId).set({'ratings': 0});
    // }
    // Source source =
    //     NetworkStatus().deviceIsOnline ? Source.serverAndCache : Source.cache;
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      print(userSnap.exists);
      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;

      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      var followerList = userSnap.data()!['followers'];
      var followeringList = userSnap.data()!['following'];

      for (var followerId in followerList) {
        var followersSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(followerId)
            .get();
        followersSnapList.add(followersSnap);
      }

      for (var followingID in followeringList) {
        var followersSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(followingID)
            .get();
        followingSnapList.add(followersSnap);
      }

      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      print('Firebase error ' + e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildButton(
          BuildContext context, String value, String text, int whichscreen) =>
      GestureDetector(
        child: MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 4),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => followerScreen(
                followersSnapList: followersSnapList,
                followingSnapList: followingSnapList,
                whichScreen: whichscreen,
              ),
            ),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColor.secondary.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 2),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.secondary.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => followerScreen(
              followersSnapList: followersSnapList,
              followingSnapList: followingSnapList,
              whichScreen: whichscreen,
            ),
          ),
        ),
      );

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );
  @override
  Widget build(BuildContext context) {
    // print(snap['postUrl']);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: buildAppBar(context),
            body: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    color: AppColor.primary,
                    //   image: AssetImage('../../assets/images/background.png'),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  child: Column(children: [
                    ProfileWidget(
                        imagePath: userData['photoUrl'],
                        onPressed: () => _selectImage(context),
                        uid: widget.uid),
                    const SizedBox(height: 24),
                    buildName(),
                  ]),
                ),

                const SizedBox(height: 24),
                // Center(child: buildUpgradeButton()),
                // const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildButton(context, postLen.toString(), 'Goods', 1),
                    buildDivider(),
                    buildButton(context, followers.toString(), 'Followers', 0),
                    buildDivider(),
                    buildButton(context, following.toString(), 'Following', 1),
                  ],
                ),

                buildAbout(),
                const SizedBox(height: 16),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Product Released",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return Container(
                                child: GestureDetector(
                                  child: Image(
                                    image: NetworkImage(snap['postUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                  onTap: () => {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsView(
                                                snap: snapshot.data!.docs[index]
                                                    .data()),
                                      ),
                                    )
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget buildName() => Column(
        children: [
          Text(
            userData['username'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userData['email'],
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade To PRO',
        onClicked: () {},
      );

  Widget buildAbout() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About me",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.secondary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userData['bio'],
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: AppColor.secondary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
}
