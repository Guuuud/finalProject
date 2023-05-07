import 'package:flutter/material.dart';

class CategoryItems extends StatelessWidget {
  final double height,
      width,
      radius,
      titleSize,
      amountSize,
      paddingHorizontal,
      paddingVertical;
  final String image, title, amount;
  final Color color;
  final align, blendMode;
  const CategoryItems({
    required this.height,
    required this.width,
    required this.radius,
    required this.titleSize,
    required this.image,
    required this.title,
    required this.color,
    required this.align,
    required this.amount,
    // required this.lblColor,
    required this.blendMode,
    required this.amountSize,
    required this.paddingHorizontal,
    required this.paddingVertical,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.9), BlendMode.dstATop),
              ),
            ),
          ),
          Align(
            alignment: align,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(color: Colors.white, fontSize: titleSize),
                  ),
                  WidgetSpan(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontal,
                        vertical: paddingVertical,
                      ),
                      decoration: BoxDecoration(
                        // color: lblColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: amount,
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: amountSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
