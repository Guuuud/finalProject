import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/utils/colors.dart';
import 'package:secondhand/utils/global_variable.dart';
import 'package:secondhand/widgets/post_card.dart';
import 'package:secondhand/widgets/new_post_card.dart';
import 'package:secondhand/screens/post/product_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../widgets/marketky/category_card.dart';
import '../../widgets/marketky/custom_icon_button_widget.dart';
import '../../widgets/marketky/dummy_search_widget_1.dart';

class NewFeedScreen extends StatefulWidget {
  const NewFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewFeedScreen> createState() => _NewFeedScreenState();
}

class _NewFeedScreenState extends State<NewFeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_secondhand.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(25),
            crossAxisCount: 2, // 每行个数
            scrollDirection: Axis.vertical, // 滚动方向
            itemCount: snapshot.data!.docs.length, // 列表总数
            itemBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 41, 239, 6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xffEEEEEE),
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
                    index % 2 == 0
                        ? AspectRatio(
                            aspectRatio: 1 / 1,
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
                          )
                        : AspectRatio(
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
                        snapshot.data!.docs[index].data()['title'].toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Color.fromARGB(255, 232, 11, 11),
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
                        style: TextStyle(fontSize: 24, color: Colors.black26),
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
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Text(
                                  snapshot.data!.docs[index]
                                      .data()['username']
                                      .toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
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
                                color: Colors.red,
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
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1), // 重点
            mainAxisSpacing: 20, // 间距
            crossAxisSpacing: 20, // 间距
          );
        },
      ),
    );
  }
}
