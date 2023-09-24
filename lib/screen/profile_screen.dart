import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ksica/component/input_box.dart';
import 'package:ksica/component/profile_image.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/query/profile.dart';
import 'package:ksica/utils/space.dart';
import 'package:provider/provider.dart';
import '../Layout/sub_layout.dart';
import '../provider/auth.dart';
import '../query/profile_image.dart';

class ProfileScreenStyle {
  static const double boxWidth = 270.0;
  static const double boxHeight = 50.0;
  static const double buttonFontSize = 16.0;
  static const FontWeight buttonFontWeight = FontWeight.w600;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  // bool _showContainer = false;
  final double _profileImageSize = 100.0;

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await deleteProfileImage();
      await uploadProfileImage(_image!);
    } else {
      print('No image selected.');
    }
  }

  // void toggleContainerVisibility() {
  //   setState(() {
  //     _showContainer = !_showContainer;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SubLayout(
      title: "프로필 수정하기",
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: lightBlue,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 170.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                // fit: StackFit.expand,
                children: [
                  Positioned(
                    child: ProfileImage(profileImageSize: _profileImageSize),
                  ),
                  Positioned(
                    top: 3.0,
                    left: _profileImageSize - 37.0,
                    child: GestureDetector(
                      onTap: _getImageFromGallery,
                      child: Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          color: mainBlack,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 17.0,
                          color: mainWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const _Profile(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Profile extends StatefulWidget {
  const _Profile();

  @override
  State<_Profile> createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final TextEditingController controllerUserName = TextEditingController();

  Future<void> save() async {
    Map newProfile = {};
    if (controllerEmail.text.isNotEmpty) {
      newProfile["email"] = controllerEmail.text;
    }
    if (controllerUserName.text.isNotEmpty) {
      newProfile["username"] = controllerUserName.text;
    }
    if (controllerPassword.text.isNotEmpty) {
      newProfile["password"] = controllerPassword.text;
    }
    print(newProfile);
    final response = await updateProfile(newProfile);
    print(response);
  }

  Widget saveButton() {
    return SizedBox(
      width: ProfileScreenStyle.boxWidth,
      height: ProfileScreenStyle.boxHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: save,
        child: const Text(
          "저장하기",
          style: TextStyle(
            fontSize: ProfileScreenStyle.buttonFontSize,
            fontWeight: ProfileScreenStyle.buttonFontWeight,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> token = JwtDecoder.decode(
      Provider.of<Auth>(
        context,
        listen: false,
      ).token,
    );

    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Label(
            text: "email",
            width: ProfileScreenStyle.boxWidth,
          ),
          InputBox(
              title: token["email"],
              controller: controllerEmail,
              height: ProfileScreenStyle.boxHeight,
              width: ProfileScreenStyle.boxWidth),
          hspace(20.0),
          const Label(text: "username", width: ProfileScreenStyle.boxWidth),
          InputBox(
              title: token["username"],
              controller: controllerUserName,
              height: ProfileScreenStyle.boxHeight,
              width: ProfileScreenStyle.boxWidth),
          hspace(20.0),
          const Label(
            text: "password",
            width: ProfileScreenStyle.boxWidth,
          ),
          InputBox(
              title: "password",
              controller: controllerPassword,
              height: ProfileScreenStyle.boxHeight,
              width: ProfileScreenStyle.boxWidth),
          hspace(20.0),
          saveButton(),
        ],
      ),
    );
  }
}
