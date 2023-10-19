import 'package:flutter/material.dart';

import '../../config/style.dart';
import '../../utils/space.dart';

class LoadingDialog extends StatelessWidget {
  final String text;
  const LoadingDialog({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: lightBlue,
        child: Container(
          alignment: Alignment.center,
          height: 150.0,
          width: 300.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: mainWhite,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: mainBlack,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              hspace(30.0),
              const SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  color: mainBlue,
                  strokeWidth: 5.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
