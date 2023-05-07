import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/screens/general/homepage.dart';
import 'package:secondhand/screens/general/secondhome.dart';
import 'package:secondhand/screens/post/add_post_screen.dart';
import 'package:secondhand/screens/general/new_feed_screen.dart';
import 'package:secondhand/screens/post/product_screen.dart';
import 'package:secondhand/screens/func/search_screen.dart';
import 'package:secondhand/screens/user/collection_screen.dart';
import 'package:secondhand/screens/user/profile_page.dart';
import 'package:secondhand/screens/general/category.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  HomePage(),
  FeedsPage(),
  const AddPostScreen(),
  // const NewFeedScreen(),
  // FeedsPage(),

  ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid)
  // ProfileScreen(
  //   uid: FirebaseAuth.instance.currentUser!.uid,
  // ),
];
