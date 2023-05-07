import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/models/user.dart';
//import 'package:secondhand/utils/user_preferences.dart';
import 'package:secondhand/widgets/appbar_widget.dart';
import 'package:secondhand/widgets/button_widget.dart';
import 'package:secondhand/widgets/numbers_widget.dart';
import 'package:secondhand/widgets/profile_widget.dart';
import 'package:secondhand/resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:secondhand/resources/firestore_methods.dart';
import 'package:flutter/gestures.dart';

import 'package:secondhand/widgets/profileWidgets/text_field_widget.dart';
import 'package:secondhand/models/user.dart';

class EditProfilePage extends StatefulWidget {
  final userSnap;
  const EditProfilePage({Key? key, required this.userSnap}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String uid = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      uid = userSnap['uid'];
    } catch (e) {
      print(e);
    }
  }

  editUserProfile(String uid) {
    String res = "Some error occurred";

    if (uid != null) {
      final followersSnap =
          FirebaseFirestore.instance.collection('users').doc("uid");
      followersSnap.update({
        "username": _nameController.text,
        "bio": _bioController.text
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                  uid: widget.userSnap['uid'],
                  imagePath: widget.userSnap['photoUrl'].toString(),
                  onPressed: () => {}),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'Full Name',
                text: widget.userSnap['username'].toString(),
                onChanged: (name) {},
                controller: _nameController,
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'About',
                text: widget.userSnap['bio'].toString(),
                maxLines: 5,
                controller: _bioController,
                onChanged: (about) {},
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: editUserProfile(uid),
          child: Container(
            child: const Text(
              'Edit Profile',
            ),
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
