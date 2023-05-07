import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/screens/func/setting_page.dart';
import 'package:secondhand/utils/app_color.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = CupertinoIcons.settings;

  return AppBar(
    leading: GestureDetector(
      child: BackButton(),
      onTap: () => Navigator.of(context).pop(),
    ),
    backgroundColor: AppColor.primary,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(icon),
        color: Colors.white,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => settingPage()),
        ),
      ),
    ],
  );
}
