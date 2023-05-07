import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand/providers/user_provider.dart';
import 'package:secondhand/resources/firestore_methods.dart';
import 'package:secondhand/utils/app_color.dart';
import 'package:secondhand/utils/colors.dart';
import 'package:secondhand/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart' as model;

//import 'package:multi_image_picker/multi_image_picker.dart';
const double borderWidth = 10;
const double gapBox = 10;
const List<String> list = <String>[
  'Gaming',
  'Clothes',
  'Outdoor',
  'Food',
  'Equipment',
  'others'
];

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  // _AddPostScreenState createState() => _AddPostScreenState();
  State<AddPostScreen> createState() => _AddPostScreenState();
  // @override
  // State<AddPostScreen> createState() => _DropdownButtonExampleState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  var userData = {};
  User currentUser = FirebaseAuth.instance.currentUser!;
  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      userData = userSnap.data()!;
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Uint8List? _file;
  bool _isLoading = false;
  String dropdownValue = 'Gaming';
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<Uint8List>? imageFileList = [];
  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Create a Post',
            style: TextStyle(color: AppColor.primary),
          ),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Take a photo',
                  style: TextStyle(color: AppColor.primary),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: AppColor.primary),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // final List<Uint8List>? selectedImages =
                  //     await imagePicker.pickMultiImage();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
          ],
        );
      },
    );
  }

  void postImage(
      String category, String uid, String username, String profImage) async {
    print("HELLOEEeeeee");
    setState(() {
      _isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
        double.parse(_priceController.text),
        _titleController.text,
        category,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    print("fdsfdsafsd");
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                color: AppColor.primary,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                    onPressed: () => postImage(
                          dropdownValue,
                          userData['uid'],
                          userData['username'],
                          userData['photoUrl'],
                        ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Post",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ))
              ],
            ),

            // POST FORM
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 24),
              physics: BouncingScrollPhysics(),
              children: [
                // Section 1 - Header
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 12),
                  child: Text(
                    "Edit your goods",
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'poppins',
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 32),
                  child: Text(
                    'Make good tilte and description so that your goods can get maximum exposure',
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        fontSize: 12,
                        height: 150 / 100),
                  ),
                ),
                // Section 2  - Form
                // Full Name

                TextField(
                  style: TextStyle(color: AppColor.fieldTextColor),
                  controller: _titleController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: AppColor.hintTextColor),
                    hintText: 'Title',
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
                // Username
                TextField(
                  style: TextStyle(color: AppColor.fieldTextColor),
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: AppColor.hintTextColor),
                    hintText: 'Price',
                    prefixIcon: Container(
                      padding: EdgeInsets.all(12),
                      child: Text('¥',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primary)),
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
                // Email
                SizedBox(
                  height: 60,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 220, minHeight: 140),
                    child: TextField(
                      style: TextStyle(color: AppColor.fieldTextColor),

                      maxLines: 8,
                      controller: _descriptionController,
                      autofocus: false,
                      // keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: AppColor.hintTextColor),
                        hintText: 'Description',
                        prefixIcon: Container(
                          padding: EdgeInsets.all(12),
                          child: SvgPicture.asset(
                              '../../assets/icons/Message.svg',
                              color: AppColor.primary),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.border, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.primary, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: AppColor.primarySoft,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Text(
                //   'Selected Value: $dropdownValue',
                //   style: TextStyle(
                //       color: Colors.red[600], fontWeight: FontWeight.bold),
                // ),
                SizedBox(height: 16),
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    //Title
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                // Password
              ],
            ),
          );

    //   body: ListView(
    //     shrinkWrap: true,
    //     padding: EdgeInsets.symmetric(horizontal: 4),
    //     physics: BouncingScrollPhysics(),
    //     children: [
    //       DropdownButton<String>(
    //         value: dropdownValue,
    //         icon: const Icon(Icons.arrow_downward),
    //         elevation: 16,
    //         style: const TextStyle(color: Colors.deepPurple),
    //         underline: Container(
    //           height: 2,
    //           color: Colors.deepPurpleAccent,
    //         ),
    //         onChanged: (String? value) {
    //           // This is called when the user selects an item.
    //           setState(() {
    //             dropdownValue = value!;
    //           });
    //         },
    //         items: list.map<DropdownMenuItem<String>>((String value) {
    //           return DropdownMenuItem<String>(
    //             value: value,
    //             child: Text(value),
    //           );
    //         }).toList(),
    //       ),
    //       isLoading
    //           ? const LinearProgressIndicator()
    //           : const Padding(padding: EdgeInsets.only(top: 0.0)),
    //       const Divider(),
    //       Stack(
    //         alignment: Alignment.center,
    //         children: [
    //           //Title
    //           SizedBox(
    //             height: 200,
    //             width: 200,
    //             child: AspectRatio(
    //               aspectRatio: 487 / 451,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                     image: DecorationImage(
    //                   fit: BoxFit.fill,
    //                   alignment: FractionalOffset.topCenter,
    //                   image: MemoryImage(_file!),
    //                 )),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       const Divider(),
    //     ],
    //   ),
    // );
  }
}
