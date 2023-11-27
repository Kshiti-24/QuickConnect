import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../Helpers/dialogs.dart';
import '../Models/chat_user.dart';
import '../Network/APIs.dart';
import '../main.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ChatUser> list = [];
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("QuickConnect"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            //for showing progress dialog
            Dialogs.showProgressBar(context);

            await APIs.updateActiveStatus(false);

            log("\nUser has signed out");
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();

            //for hiding progress dialog
            Navigator.pop(context);

            //for moving to home screen
            Navigator.pop(context);

            APIs.auth = FirebaseAuth.instance;

            //replacing home screen with login screen
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          shape: StadiumBorder(),
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          backgroundColor: Colors.redAccent,
          label: const Text(
            "Logout",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // add space
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.03,
                  ),

                  // user profile
                  Stack(children: [
                    _image != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(size.height * .1),
                            child: Image.file(File(_image!),
                                width: size.height * .2,
                                height: size.height * .2,
                                fit: BoxFit.cover))
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(size.height * .1),
                            child: CachedNetworkImage(
                              width: size.height * .2,
                              height: size.height * .2,
                              fit: BoxFit.cover,
                              imageUrl: widget.user.image
                                  .replaceAll("s96-c", "s400-c"),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                      child: Icon(CupertinoIcons.person)),
                            ),
                          ),
                    Positioned(
                        bottom: size.height * 0,
                        right: size.width * 0,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomSheet();
                          },
                          elevation: 1,
                          shape: CircleBorder(),
                          color: Colors.white,
                          child: const Icon(Icons.edit, color: Colors.blue),
                        ))
                  ]),

                  // add space
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.03,
                  ),

                  //for email
                  Text(
                    widget.user.email,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  // add space
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.05,
                  ),

                  //textformfield
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.selfInfo.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(
                          CupertinoIcons.person,
                          color: Colors.blue,
                        ),
                        hintText: "Eg, Kshitiz Agarwal",
                        label: const Text("Name")),
                  ),

                  // add space
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.02,
                  ),

                  //textformfield
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.selfInfo.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(
                          CupertinoIcons.info,
                          color: Colors.blue,
                        ),
                        hintText: "Eg, Hey I'm using QuickConnect",
                        label: const Text("About")),
                  ),

                  // add space
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.05,
                  ),

                  //Elevated Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Colors.blue,
                        minimumSize:
                            Size(size.width * 0.5, size.height * 0.06)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile Updated Successfully!');
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Update",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: size.height * 0.03, bottom: size.height * 0.05),
            children: [
              const Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(size.width * 0.3, size.height * 0.15),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!)).then(
                              (value) => Dialogs.showSnackbar(
                                  context, 'Profile Updated Successfully!'));

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset("assets/images/add_image.png")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(size.width * 0.3, size.height * 0.15),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!)).then(
                              (value) => Dialogs.showSnackbar(
                                  context, 'Profile Updated Successfully!'));

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset("assets/images/camera.png"))
                ],
              )
            ],
          );
        });
  }
}
