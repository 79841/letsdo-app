import 'package:flutter/material.dart';

import '../../config/style.dart';
import '../../utils/space.dart';

class WarningDialog extends StatelessWidget {
  final String text;
  const WarningDialog({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 16.0),
        child: Container(
          alignment: Alignment.center,
          height: 150.0,
          width: 300.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: mainWhite,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              hspace(30.0),
              Text(
                text,
                style: const TextStyle(
                  color: mainBlack,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              hspace(30.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  height: 40.0,
                  width: 300.0,
                  child: const Text(
                    "확인",
                    style: TextStyle(
                      color: mainWhite,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
