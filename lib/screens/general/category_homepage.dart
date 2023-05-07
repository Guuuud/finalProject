import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondhand/screens/post/product_screen.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/widgets/marketky/carttile.dart';

import '../../widgets/marketky/explore_card_widget.dart';

class categoryPage extends StatefulWidget {
  final String categoryWord;
  const categoryPage({super.key, required this.categoryWord});

  @override
  State<categoryPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            children: [
              Text(
                widget.categoryWord,
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where("category", isEqualTo: widget.categoryWord)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
              children: List.generate(snapshot.data!.docs.length, (index) {
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
        ));
  }
}
