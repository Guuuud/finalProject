import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/screens/auth/login_screen.dart';
import 'package:secondhand/screens/general/category.dart' as Ca;
import 'package:secondhand/screens/general/category.dart';
import 'package:secondhand/screens/general/category_homepage.dart';
import 'package:secondhand/screens/general/search_c_screen.dart';
import 'package:secondhand/screens/post/product_screen.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/models/category.dart';
import 'package:secondhand/widgets/marketky/category_card.dart';
import 'package:secondhand/widgets/marketky/custom_icon_button_widget.dart';
import 'package:secondhand/widgets/marketky/dummy_search_widget_1.dart';
import 'dart:math';
import '../../resources/auth_methods.dart';
// import 'package:secondhand/widgets/marketky/category.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<QuerySnapshot<Map<String, dynamic>>> getRandomPosts() async {
    final QuerySnapshot<Map<String, dynamic>> postSnap =
        await FirebaseFirestore.instance.collection('posts').get();

    final int totalPosts = postSnap.docs.length;

    final List<int> randomIndices =
        List.generate(6, (index) => Random().nextInt(totalPosts));

    final List<String> postIds = [];
    for (int i = 0; i < randomIndices.length; i++) {
      postIds.add(postSnap.docs[randomIndices[i]].id);
    }

    final QuerySnapshot<Map<String, dynamic>> randomPostSnap =
        await FirebaseFirestore.instance
            .collection('posts')
            .where(FieldPath.documentId, whereIn: postIds)
            .get();

    return randomPostSnap;
  }

  Future<void> addToRecommendations(String userId) async {
    // Delete the existing recommendation subcollection
    QuerySnapshot existingRecommendations = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('recommendation')
        .get();
    List<Future<void>> deleteOperations = [];
    for (DocumentSnapshot doc in existingRecommendations.docs) {
      deleteOperations.add(doc.reference.delete());
    }
    await Future.wait(deleteOperations);
    // Get a reference to the user document
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Check if the recommendation subcollection exists
    bool exists = await userRef
        .collection('recommendation')
        .limit(1)
        .get()
        .then((value) => value.docs.isNotEmpty);

    // Create the recommendation subcollection if it doesn't exist
    if (!exists) {
      await userRef.collection('recommendation').add({});
    }
    deleteOperations = [];
    QuerySnapshot existingRecommendationss = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('recommendation')
        .get();
    for (DocumentSnapshot doc in existingRecommendationss.docs) {
      deleteOperations.add(doc.reference.delete());
    }
    await Future.wait(deleteOperations);
    // Get a reference to the recommendation subcollection
    CollectionReference recRef = userRef.collection('recommendation');

    // Retrieve 10 random posts from the posts collection
    QuerySnapshot postSnap = await getRandomPosts();

    List<DocumentSnapshot> posts = postSnap.docs;
    // const recRef =  FirebaseFirestore.instance.collection(user/${userId}/recommendation);
    // Add each post to the recommendation subcollection
    for (var post in posts) {
      var postData = post.data();

      await recRef.add(post.data());
      // await userRef.collection('recommendation').add(postData);
    }
  }

  var productData = {};

  var categoryName = {
    "Gaming device",
    "Clothes&Shoes",
    "Outdoor activicy",
    "Equipment",
    //
    "Electronical device",
    "Phones&PC",
    "Food",
    "Virtual Services"
  };

  var categoryNameUrl = {
    "../../assets/images/category/game.jpeg",
    "../../assets/images/category/clothes.jpeg",
    "../../assets/images/category/bike.jpeg",
    "../../assets/images/category/equipment.jpeg",
    "../../assets/images/category/elec.jpeg",
    "../../assets/images/category/phones.jpeg",
    "../../assets/images/category/food.jpeg",
    "../../assets/images/category/pdf.png",
  };
  var categoryNameShort = [
    "Gaming",
    "Clothes",
    "Outdoor",
    "Equipment",
    "Food",
  ];
  var categoryIconNameShort = [
    Icons.gamepad_rounded,
    Icons.shop,
    Icons.map_outlined,
    Icons.fitness_center,
    Icons.food_bank,
  ];

  @override
  Widget build(BuildContext context) {
    // addToRecommendations(FirebaseAuth.instance.currentUser!.uid);
    return GestureDetector(
      // onDoubleTap: addToRecommendations(FirebaseAuth.instance.currentUser!.uid),
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            // Section 1
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColor.primary,
                // image: DecorationImage(
                //   image: AssetImage('../../assets/images/background.png'),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 26),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find the best \noutfit for you.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            height: 150 / 100,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Row(
                          children: [
                            CustomIconButtonWidget(
                                type: 1,
                                margin: EdgeInsets.all(1),
                                onTap: () {},
                                value: 0,
                                icon: Icon(
                                  Icons.chat,
                                  color: AppColor.primary,
                                )),
                            CustomIconButtonWidget(
                                type: 0,
                                onTap: () {},
                                value: 2,
                                margin: EdgeInsets.only(left: 16),
                                icon: Icon(
                                  Icons.settings,
                                  color: AppColor.primary,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DummySearchWidget1(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Section 2 - category
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.secondary,
              padding: EdgeInsets.only(top: 12, bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CategoryScreen(
                                    // cateName: categoryName,
                                    // cateUrl: categoryNameUrl,
                                    ),
                              ),
                            ),
                          },
                          child: Text(
                            'View More',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Category list
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    height: 96,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 16);
                      },
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          catename: categoryNameShort[index],
                          iconame: categoryIconNameShort[index],
                          // data: categoryData[index],
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => categoryPage(
                                  categoryWord: categoryNameShort[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Section 3 - banner
            // Container(
            //   height: 106,
            //   padding: EdgeInsets.symmetric(vertical: 16),
            //   child: ListView.separated(
            //     padding: EdgeInsets.symmetric(horizontal: 16),
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 3,
            //     separatorBuilder: (context, index) {
            //       return SizedBox(width: 16);
            //     },
            //     itemBuilder: (context, index) {
            //       return Container(
            //         width: 230,
            //         height: 106,
            //         decoration: BoxDecoration(
            //             color: AppColor.primarySoft,
            //             borderRadius: BorderRadius.circular(15)),
            //       );
            //     },
            //   ),
            // ),

            // // Section 4 - Flash Sale

            // Section 5 - product list

            Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Text(
                'Todays recommendation...',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('recommendation')
                  .snapshots(),
              // FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  return StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    crossAxisCount: 2, // 每行个数
                    scrollDirection: Axis.vertical, // 滚动方向
                    itemCount: snapshot.data!.docs.length, // 列表总数
                    itemBuilder: (BuildContext context, int index) => Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.hintTextColor,
                                offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                                blurRadius: 4, //阴影模糊程度
                                spreadRadius: 1 //阴影扩散程度
                                ),
                          ]),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDetailsView(
                                snap: snapshot.data!.docs[index].data()),
                          ));
                        },
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 4 / 5,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data!.docs[index]
                                            .data()['postUrl']
                                            .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                snapshot.data!.docs[index]
                                    .data()['title']
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: AppColor.fieldTextColor,
                                ),
                              ),
                            ),
                            index % 2 != 0 ? SizedBox(height: 10) : SizedBox(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                snapshot.data!.docs[index]
                                    .data()['description']
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black26),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
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
                                                snapshot.data!.docs[index]
                                                    .data()['profImage']
                                                    .toString(),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                      SizedBox(width: 10),
                                      // Container(
                                      //   child: Text(
                                      //     snapshot.data!.docs[index]
                                      //         .data()['username']
                                      //         .toString(),
                                      //     maxLines: 1,
                                      //     overflow: TextOverflow.ellipsis,
                                      //     style: TextStyle(
                                      //       color: Colors.black,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "¥" +
                                        snapshot.data!.docs[index]
                                            .data()['priceTag']
                                            .toString(),
                                    style: TextStyle(
                                        color: AppColor.fieldTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    staggeredTileBuilder: (int index) =>
                        StaggeredTile.fit(1), // 重点
                    mainAxisSpacing: 20, // 间距
                    crossAxisSpacing: 20, // 间距
                  );
                } else {
                  return Text(
                    "NODATfdasfasdfasdfasdfasdfsdafasdfasdfsafsdaA",
                    style: TextStyle(color: Colors.amber),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
