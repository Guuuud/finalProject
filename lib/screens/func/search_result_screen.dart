import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/screens/func/setting_page.dart';
import 'package:secondhand/screens/post/product_screen.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/utils/utils.dart';

import '../../utils/colors.dart';
import '../../utils/global_variable.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.keyword});
  final String keyword;
  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  var postSnap;
  getData() async {
    // postSnap = await FirebaseFirestore.instance
    //     .collection('posts')
    //     //这里要改成Title
    //     .where("description", isGreaterThanOrEqualTo: widget.keyword)
    //     .where("description", isLessThanOrEqualTo: widget.keyword + "\uf7ff")
    //     .snapshots();

    postSnap = FirebaseFirestore.instance
        .collection('posts')
        //这里要改成Title
        .where("Title", isGreaterThanOrEqualTo: widget.keyword)
        .where("Title", isLessThanOrEqualTo: widget.keyword + "\uf7ff")
        .snapshots();
    // try {
    //   for (var i in postSnap.docs) {
    //     if (i['title'].contains(keyword)) {
    //       finalPostSnap.add(i['postId']);
    //     }
    //   }
    // } catch (e) {
    //   showSnackBar(context, e.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    final width = MediaQuery.of(context).size.width;

    var _keywordscontroller;
    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            '../../assets/icons/Arrow-left.svg',
            color: Colors.white,
          ),
        ),
        title: Container(
          height: 40,
          child: TextField(
            controller: _keywordscontroller,
            autofocus: false,
            style: TextStyle(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              hintStyle:
                  TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
              hintText: 'Find a products...',
              prefixIcon: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: SvgPicture.asset('../../assets/icons/Search.svg',
                        color: Colors.white),
                  ),
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchResultScreen(
                            keyword: _keywordscontroller.toString(),
                          ),
                        ),
                      )),
              // prefixIcon: Container(
              //   padding: EdgeInsets.all(10),
              //   child: SvgPicture.asset('../../assets/icons/Search.svg',
              //       color: Colors.white),
              // ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              fillColor: Colors.white.withOpacity(0.1),
              filled: true,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: StreamBuilder(
        stream: postSnap,
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
