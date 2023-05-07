import 'package:secondhand/widgets/appbar_widget.dart';
import 'package:secondhand/widgets/categoryExtentWidget/categoryItems.dart';
import 'package:secondhand/widgets/categoryExtentWidget/categoryView.dart';
import 'package:flutter/material.dart';

// import '../constant.dart';

class CategoryScreen extends StatefulWidget {
  List categoryName = [
    "Gaming device",
    "Clothes&Shoes",
    "Outdoor activicy",
    "Equipment",
    //
    "Electronical device",
    "Phones&PC",
    "Food",
    "Virtual Services"
  ];

  List categoryNameUrl = [
    "../../assets/images/category/game.jpeg",
    "../../assets/images/category/clothes.jpeg",
    "../../assets/images/category/bike.jpeg",
    "../../assets/images/category/equipment.jpeg",
    "../../assets/images/category/elec.jpeg",
    "../../assets/images/category/phones.jpeg",
    "../../assets/images/category/food.jpeg",
    "../../assets/images/category/pdf.png",
  ];

  CategoryScreen({
    super.key,
  });
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isList = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      // appBar: Container(alignment: MainAxisAlignment),
      body: Categoryview(
        direction: Axis.vertical,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        column: isList ? 1 : 2,
        ratio: isList ? 2.6 : 1.3,
        items: 8,
        itemBuilder: (context, index) {
          return CategoryItems(
            // lblColor: Colors.blue,
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            paddingHorizontal: 0.0,
            paddingVertical: 0.0,
            align: Alignment.center,
            radius: 3,
            blendMode: BlendMode.difference,
            color: Colors.grey,
            image: widget.categoryNameUrl[index],
            title: widget.categoryName[index],
            titleSize: 20.0,
            amount: "",
            amountSize: 0.0,
          );
        },
      ),
    );
  }
}
