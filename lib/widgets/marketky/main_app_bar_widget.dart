import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/screens/general/search_c_screen.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/widgets/marketky/custom_icon_button_widget.dart';
import 'package:secondhand/widgets/marketky/dummy_search_widget2.dart';

// import 'package:marketky/views/screens/search_page.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int cartValue;
  final int chatValue;

  MainAppBar({
    required this.cartValue,
    required this.chatValue,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: AppColor.primary,
      elevation: 0,
      title: Row(
        children: [
          DummySearchWidget2(),
          CustomIconButtonWidget(
            type: 1,
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
            },
            value: widget.cartValue,
            margin: EdgeInsets.only(left: 16),
            icon: Icon(
              Icons.chat,
              color: AppColor.primary,
            ),
          ),
          CustomIconButtonWidget(
            type: 0,
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagePage()));
            },
            value: widget.chatValue,
            margin: EdgeInsets.only(left: 16),
            icon: Icon(
              Icons.badge,
              color: AppColor.primary,
            ),
          ),
        ],
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
