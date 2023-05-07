import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:secondhand/utils/app_color.dart';

class EditProfile extends StatefulWidget {
  final userSnap;

  const EditProfile({super.key, required this.userSnap});
  // const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editBioController = TextEditingController();

  editUser() {
    User currentUser = FirebaseAuth.instance.currentUser!;
    // var userData =
    //     FirebaseFirestore.instance.collection('user').doc(currentUser.uid);
    print(currentUser.uid);
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      "username": _editNameController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    // _editNameController = TextEditingController(text: "FADSFASD");
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: BouncingScrollPhysics(),
        children: [
          TextField(
            style: TextStyle(color: AppColor.fieldTextColor),
            controller: _editNameController,
            autofocus: false,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: AppColor.hintTextColor),
              hintText: 'Name',
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset('../../assets/icons/Profile.svg',
                    color: AppColor.primary),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            style: TextStyle(color: AppColor.fieldTextColor),
            controller: _editBioController,
            autofocus: false,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: AppColor.hintTextColor),
              hintText: 'Bio',
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset('../../assets/icons/Profile.svg',
                    color: AppColor.primary),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
          ),
          SizedBox(height: 16),
          // Column(
          //   children: [
          //     TextField(
          //       controller: _editBioController,
          //       autofocus: false,
          //       decoration: InputDecoration(
          //         prefixIcon: Container(
          //           padding: EdgeInsets.all(12),
          //           child: SvgPicture.asset('../../assets/icons/Profile.svg',
          //               color: AppColor.primary),
          //         ),
          //         contentPadding:
          //             EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: AppColor.border, width: 1),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: AppColor.primary, width: 1),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         fillColor: AppColor.primarySoft,
          //         filled: true,
          //       ),
          //     ),
          //   ],
          // ),
          ElevatedButton(
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => OTPVerificationPage()));
              editUser();
            },
            child: Text(
              'Save',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: 'poppins'),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Edit your profile',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
            color: AppColor.primary,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}
