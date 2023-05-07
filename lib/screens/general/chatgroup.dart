import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secondhand/screens/general/homepage.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/widgets/marketky/mess_tile_widget.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout.dart';
import '../../responsive/web_screen_layout.dart';

class chatGroup extends StatefulWidget {
  @override
  _chatGroupState createState() => _chatGroupState();
}

class _chatGroupState extends State<chatGroup> {
  // List<Message> listMessage = MessageService.messageData;
  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser!;
    print(currentUser.uid + "++++++++++++++");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text('Message',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            Text('1 Unreaded',
                style: TextStyle(
                    fontSize: 10, color: Colors.black.withOpacity(0.7))),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  ),
                ),
                (route) => false);
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
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
              .collection('users')
              .doc(currentUser.uid)
              .collection('chats')
              .snapshots(),
          builder: (context, snapshot) {
            return ListView.separated(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (context, index) {
                  return SizedBox();
                },
                itemBuilder: (context, index) {
                  return MessageTileWidget(
                    snap: snapshot.data!.docs[index].data(),
                  );
                });
          }),
    );
  }
}
