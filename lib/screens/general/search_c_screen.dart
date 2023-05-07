import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/models/Search.dart';
import 'package:secondhand/screens/func/search_result_screen.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/widgets/marketky/popular_search_card.dart';
import 'package:secondhand/widgets/marketky/search_history_tile.dart';
import 'package:secondhand/widgets/marketky/services/SearchService.dart';

import '../../models/user.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _keywordscontroller = TextEditingController();
  List<SearchHistory> listSearchHistory = SearchService.listSearchHistory;
  List<PopularSearch> listPopularSearch = SearchService.listPopularSearch;
  List<String> searchHisData = [];
  @override
  void initState() {
    super.initState();
    showSearchHistory();
  }

  addToSearchHistory() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'searchHistory': FieldValue.arrayUnion([_keywordscontroller.text])
    });
  }

  clearSearchHistory() async {
    var searchHis = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var i in searchHis.data()!['searchHistory']) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'searchHistory': FieldValue.arrayRemove([i])
      });
    }
  }

  showSearchHistory() async {
    var searchHis = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var i in searchHis.data()!['searchHistory']) {
      setState(() {
        searchHisData.add(i);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios)),
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
                    padding: EdgeInsets.all(10), child: Icon(Icons.search)),
                onTap: () => [
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchResultScreen(
                        keyword: _keywordscontroller.toString(),
                      ),
                    ),
                  ),
                  addToSearchHistory(),
                ],
              ),

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
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Search History
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Search history...',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: searchHisData.length,
                itemBuilder: (context, index) {
                  // return SearchHistoryTile(
                  //   data: searchHisData[index],
                  //   onTap: () {

                  //   },
                  // );
                  return GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColor.primarySoft,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        searchHisData[index],
                        style: TextStyle(color: AppColor.secondary),
                      ),
                    ),
                  );
                  // return Text(
                  //   searchHisData[index],
                  //   style: TextStyle(color: Colors.blueAccent),
                  // );
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    clearSearchHistory();
                  },
                  child: Text(
                    'Delete search history',
                    style:
                        TextStyle(color: AppColor.secondary.withOpacity(0.5)),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColor.primary.withOpacity(0.3),
                    backgroundColor: AppColor.primarySoft,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                ),
              ),
            ],
          ),
          // Section 2 - Popular Search
        ],
      ),
    );
  }
}
