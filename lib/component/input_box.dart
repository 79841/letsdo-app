import 'package:flutter/material.dart';

import '../config/style.dart';

class InputBoxStyle {
  static const double inputFontSize = 15.0;
  static const FontWeight inputFontWeight = FontWeight.w400;
  static const double labelFontSize = 12.0;
  static const FontWeight labelFontWeight = FontWeight.w500;
}

class InputBox extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final double width;
  final double height;
  const InputBox(
      {required this.title,
      required this.controller,
      required this.height,
      required this.width,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainWhite,
      width: width,
      height: height,
      child: TextField(
        style: const TextStyle(
          fontSize: InputBoxStyle.inputFontSize,
          fontWeight: InputBoxStyle.inputFontWeight,
          color: mainBlack,
        ),
        controller: controller,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          labelText: title,
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 20.0),
        ),
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String text;
  final double width;
  const Label({required this.text, required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 2.0),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: InputBoxStyle.labelFontSize,
          fontWeight: InputBoxStyle.labelFontWeight,
        ),
      ),
    );
  }
}
