import 'package:flutter/material.dart';
import 'package:secondhand/models/Search.dart';
import 'package:secondhand/utils/app_color.dart';

class SearchHistoryTile extends StatelessWidget {
  SearchHistoryTile({required this.data, required this.onTap});

  final SearchHistory data;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
          '${data.title}',
          style: TextStyle(color: AppColor.primary),
        ),
      ),
    );
  }
}
