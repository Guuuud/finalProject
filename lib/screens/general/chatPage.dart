import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:secondhand/utils/app_color.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class MessageDetailPage extends StatefulWidget {
  final currentUserSnap;
  final anotherUserSnap;

  const MessageDetailPage(
      {super.key,
      required this.currentUserSnap,
      required this.anotherUserSnap});

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  TextEditingController _messageController = TextEditingController();
  Future<String> addToChat(String content) async {
    print("------------");
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    String chatIDofCurrent = widget.anotherUserSnap['uid'];
    String chatIDofAnother = widget.currentUserSnap['uid'];

    String subchatID = const Uuid().v1();
    // print(chatIDofAnother + "------------");
    DocumentReference thisone = _firestore
        .collection('users')
        .doc(widget.currentUserSnap['uid'])
        .collection('chats')
        .doc(chatIDofCurrent);
    thisone.set({
      "imageUrl": widget.anotherUserSnap['photoUrl'],
      "username": widget.anotherUserSnap['username'],
      "chatterID": widget.anotherUserSnap['uid']
    });
    thisone.collection('subChat').doc(subchatID).set({
      "senderID": widget.currentUserSnap['uid'],
      "senderName": widget.currentUserSnap['username'],
      "senderImage": widget.currentUserSnap['photoUrl'],
      "time": DateTime.now(),
      "content": content
    });

    DocumentReference thatone = _firestore
        .collection('users')
        .doc(widget.anotherUserSnap['uid'])
        .collection('chats')
        .doc(chatIDofAnother);

    thatone.set({
      "imageUrl": widget.currentUserSnap['photoUrl'],
      "username": widget.currentUserSnap['username'],
      "chatterID": widget.currentUserSnap['uid'],
    });
    thatone.collection('subChat').doc(subchatID).set({
      "senderID": widget.currentUserSnap['uid'],
      "senderName": widget.currentUserSnap['username'],
      "senderImage": widget.currentUserSnap['photoUrl'],
      "time": DateTime.now(),
      "content": content
    });

    setState(() {
      _messageController.text = "";
    });
    return "f";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColor.border,
                ),
              ),
              Text('fadfadfad',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: AppColor.primary,
            ),
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
        body: Column(
          children: [
            // Section 1 - Chat
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.currentUserSnap['uid'])
                      .collection('chats')
                      .doc(widget.anotherUserSnap['uid'])
                      .collection("subChat")
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    return ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      padding: EdgeInsets.all(16),
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      separatorBuilder: (context, index) {
                        return SizedBox();
                      },
                      itemBuilder: (context, index) {
                        return snapshot.data!.docs[index].data()['senderID'] ==
                                widget.currentUserSnap['uid']
                            ? MyBubbleChatWidget(
                                chat: snapshot.data!.docs[index]
                                    .data()['content'],
                                time: snapshot.data!.docs[index].data()['time'],
                              )
                            : SenderBubbleChatWidget(
                                chat: snapshot.data!.docs[index]
                                    .data()['content'],
                                time: snapshot.data!.docs[index].data()['time'],
                              );
                      },
                    );
                  }),
            ),
            // Section 2 - Chat Bar
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: AppColor.border, width: 1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // TextField
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type a message here...',
                        hintStyle: TextStyle(color: AppColor.primarySoft),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.border, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.border, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  // Send Button
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    width: 42,
                    height: 42,
                    child: IconButton(
                      onPressed: () => addToChat(_messageController.text),
                      icon: Icon(Icons.send_rounded,
                          color: AppColor.primary, size: 18),
                    ),
                    // child: ElevatedButton(
                    //   onPressed: () => addToChat(_messageController.text),
                    //   child: Icon(Icons.send_rounded,
                    //       color: Colors.white, size: 18),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: AppColor.primary,
                    //     padding: EdgeInsets.all(0),
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8)),
                    //     shadowColor: Colors.transparent,
                    //   ),
                    // ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).viewInsets.bottom,
              color: Colors.transparent,
            ),
          ],
        ));
  }
}

class MyBubbleChatWidget extends StatelessWidget {
  final String chat;
  final Timestamp time;

  MyBubbleChatWidget({
    required this.chat,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormat('kk:mm').format(time.toDate()),
            // DateFormat.yMMMd().format(),
            style: TextStyle(color: AppColor.secondary.withOpacity(0.5)),
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            width: MediaQuery.of(context).size.width * 65 / 100,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              chat,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, height: 150 / 100),
            ),
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SenderBubbleChatWidget extends StatelessWidget {
  final String chat;
  final Timestamp time;

  SenderBubbleChatWidget({
    required this.chat,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            width: MediaQuery.of(context).size.width * 65 / 100,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              chat,
              textAlign: TextAlign.left,
              style: TextStyle(color: AppColor.secondary, height: 150 / 100),
            ),
            decoration: BoxDecoration(
              color: AppColor.primarySoft,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
          Text(
            DateFormat('kk:mm').format(time.toDate()),
            // DateFormat.yMMMd().format(time.toDate()),
            style: TextStyle(color: AppColor.secondary.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
