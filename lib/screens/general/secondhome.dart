import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:secondhand/models/ExploreItem.dart';
import 'package:secondhand/models/ExploreUpdate.dart';
import 'package:secondhand/screens/post/product_screen.dart';

import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/widgets/marketky/explore_card_widget.dart';
import 'package:secondhand/widgets/marketky/main_app_bar_widget.dart';
import 'package:secondhand/widgets/marketky/services/ExploreService.dart';
import 'package:secondhand/widgets/marketky/update_card_widget.dart';

class FeedsPage extends StatefulWidget {
  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var a = FirebaseFirestore.instance.collection('posts').count().toString();
    print(a);
    return Scaffold(
      appBar: MainAppBar(
        cartValue: 2,
        chatValue: 2,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          // Tabbbar
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            color: AppColor.secondary,
            child: TabBar(
              onTap: (index) {
                setState(() {
                  tabController.index = index;
                });
              },
              controller: tabController,
              indicatorColor: AppColor.accent,
              indicatorWeight: 5,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w500, fontFamily: 'poppins'),
              unselectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.w400, fontFamily: 'poppins'),
              tabs: [
                Tab(
                  text: 'Recommended',
                ),
                Tab(
                  text: 'Explore',
                ),
              ],
            ),
          ),
          // Section 2 - Tab View
          IndexedStack(
            index: tabController.index,
            children: [
              // Tab 1 - Update
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('recommendation')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return UpdateCardWidget(
                          snap: snapshot.data!.docs[index].data(),
                          // data: listExploreUpdateItem[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 24,
                        );
                      },
                    );
                  }),
              // Tab 2 - Explore
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    childAspectRatio: 1 / 1,
                    physics: NeverScrollableScrollPhysics(),
                    children:
                        List.generate(snapshot.data!.docs.length, (index) {
                      return GestureDetector(
                        child: ExploreCardWidget(
                            snap: snapshot.data!.docs[index].data()),
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsView(
                                  snap: snapshot.data!.docs[index].data()),
                            ),
                          )
                        },
                      );
                    }),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
