import 'package:flutter/material.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/utils/space.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentTextStyle: const TextStyle(
        color: mainBlack,
      ),
      content: Container(
        alignment: Alignment.center,
        height: 70.0,
        width: 30.0,
        child: Column(
          children: [
            const Text("데이터를 불러오고 있습니다."),
            hspace(15.0),
            const SizedBox(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                color: mainBlue,
                strokeWidth: 6.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
