import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ksica/config/style.dart';
import '../query/profile_image.dart';

class ProfileImage extends StatefulWidget {
  final double profileImageSize;

  const ProfileImage({required this.profileImageSize, super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  double iconSize = 20.0;

  Widget defaultProfile() {
    return Container(
      width: widget.profileImageSize,
      height: widget.profileImageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.profileImageSize / 2),
        color: mainGray,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: fetchProfileImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: widget.profileImageSize,
            height: widget.profileImageSize,
            child: ClipOval(
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return defaultProfile();
        }
      },
    );
  }
}
