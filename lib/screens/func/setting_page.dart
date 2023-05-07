import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/resources/auth_methods.dart';
import 'package:secondhand/screens/auth/login_screen.dart';
import 'package:secondhand/screens/general/buyOrder.dart';
import 'package:secondhand/screens/general/orders.dart';
import 'package:secondhand/screens/user/browse_history_screen.dart';
import 'package:secondhand/screens/user/collection_screen.dart';
import 'package:secondhand/screens/user/edit_profile_new.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/widgets/appbar_widget.dart';
import 'package:secondhand/widgets/marketky/menu_tile_widget.dart';

class settingPage extends StatefulWidget {
  const settingPage({super.key});

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  var userData = {};

  getData() async {
    // Source source =
    //     NetworkStatus().deviceIsOnline ? Source.serverAndCache : Source.cache;

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      print(userSnap.exists);
      // get post lENGTH

      userData = userSnap.data()!;
    } catch (e) {}
  }

  signout() async {
    await AuthMethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'ACCOUNT',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.5),
                        letterSpacing: 6 / 100,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CollectionScreen(),
                    ));
                  },
                  // margin: EdgeInsets.only(top: 10),
                  icon: Icon(
                    Icons.collections,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'My collection',
                  subtitle: 'Lorem ipsum Dolor sit Amet',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditProfile(
                          userSnap: userData,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.mode_edit_outline_outlined,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Edit my profile',
                  subtitle: 'Lorem ipsum Dolor sit Amet',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_bag_rounded,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Order',
                  subtitle: 'Lorem ipsum Dolor sit Amet',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_bag_rounded,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Buy Order',
                  subtitle: 'Lorem ipsum Dolor sit Amet',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => brosweHistoryScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.history),
                  title: 'Browse History',
                  subtitle: 'Lorem ipsum Dolor sit Amet',
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.5),
                        letterSpacing: 6 / 100,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                MenuTileWidget(
                  subtitle: 'Lorem ipsum Dolor sit Amet',
                  onTap: () {
                    signout();
                  },
                  // onTap: signout(),
                  icon: Icon(
                    Icons.logout,
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  iconBackground: Colors.red,
                  title: 'Log Out',
                  titleColor: Colors.red,
                ),
              ],
            ),
          )
        ],
      ),
    );

    // Section 3 - Settings
  }
}
