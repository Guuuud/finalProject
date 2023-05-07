import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/screens/general/category_homepage.dart';
// import 'package:secondhand/core/model/Category.dart';

class CategoryCard extends StatelessWidget {
  final Function onTap;
  IconData iconame;
  String catename;
  CategoryCard(
      {super.key,
      required this.onTap,
      required this.iconame,
      required this.catename});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => categoryPage(
              categoryWord: catename,
            ),
          ),
        );
      },
      child: Container(
        width: 80,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 1),
              child: Icon(iconame),
            ),
            Flexible(
              child: Text(
                catename,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
