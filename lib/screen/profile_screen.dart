import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ksica/component/profile_image.dart';
import 'package:provider/provider.dart';
import '../Layout/sub_layout.dart';
import '../provider/auth.dart';
import '../query/profile_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  bool _showContainer = false;
  final double _profileImageSize = 130.0;

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

  void toggleContainerVisibility() {
    setState(() {
      _showContainer = !_showContainer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_showContainer == true) {
          toggleContainerVisibility();
        }
      },
      child: SubLayout(
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 170.0),
            child: SizedBox(
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    // fit: StackFit.expand,
                    children: [
                      Positioned(
                        child: GestureDetector(
                          onTap: toggleContainerVisibility,
                          child:
                              ProfileImage(profileImageSize: _profileImageSize),
                        ),
                      ),
                      Positioned(
                        top: _profileImageSize - 45.0,
                        left: _profileImageSize - 45.0,
                        child: IconButton(
                          onPressed: _getImageFromGallery,
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 30.0,
                            color: Colors.grey,
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
        ),
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> token = JwtDecoder.decode(
      Provider.of<Auth>(
        context,
        listen: false,
      ).token,
    );

    Widget _textBox(String text) {
      return Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16.0,
        ),
      );
    }

    return SizedBox(
      height: 50.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _textBox(
            token["username"],
          ),
          _textBox(
            token["email"],
          ),
        ],
      ),
    );
  }
}
