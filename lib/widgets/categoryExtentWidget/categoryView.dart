import 'package:flutter/material.dart';

class Categoryview extends StatelessWidget {
  final int column, items;

  final Color color;
  final double ratio, height, width;
  final direction, itemBuilder;
  const Categoryview({
    //required Key key,
    required this.column,
    required this.items,
    required this.color,
    required this.ratio,
    required this.height,
    required this.width,
    this.direction,
    this.itemBuilder,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
      child: GridView.builder(
          padding: EdgeInsets.all(5),
          scrollDirection: direction,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: column,
            childAspectRatio: ratio,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
          ),
          itemCount: items,
          itemBuilder: itemBuilder),
    );
  }
}
