import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/widgets/marketky/main_app_bar_widget.dart';
import 'package:secondhand/widgets/marketky/menu_tile_widget.dart';
import 'package:secondhand/widgets/marketky/notification_tile.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<OrderPage> {
  var userSnap;
  bool isLoading = true;
  getData() async {
    setState(() {
      isLoading = true;
    });

    var random = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .where("buyID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    setState(() {
      userSnap = random;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Column(
                children: [
                  Text(
                    'Your Purchse Record',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
            body: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                // Section 1 - Menu

                // Section 2 - Status ( LIST )
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          'My Purchase',
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.5),
                              letterSpacing: 6 / 100,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      StreamBuilder(
                          stream: userSnap,
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return NotificationTile(
                                    snap: snapshot.data!.docs[index].data());
                              },
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            );
                          }),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
