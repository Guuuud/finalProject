import 'package:flutter/material.dart';
// import 'package:marketky/core/model/ExploreItem.dart';

class ExploreCardWidget extends StatelessWidget {
  // final ExploreItem data;
  final snap;

  const ExploreCardWidget({super.key, required this.snap});
  // ExploreCardWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: Colors.red,12
        image: DecorationImage(
          image: NetworkImage(snap['postUrl'].toString()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
