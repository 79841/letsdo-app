import 'package:flutter/material.dart';
import 'package:ksica/component/chat_button.dart';

class BottomBarStyle {
  static const double height = 60.0;
  static const double iconSize = 35.0;
  static const Color bgColor = Colors.white;
  static const Color homebuttonColor = Color(0xff3b699e);
}

class BottomBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const BottomBar({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BottomBarStyle.bgColor,
      height: BottomBarStyle.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.home,
            size: BottomBarStyle.iconSize,
            color: BottomBarStyle.homebuttonColor,
          ),
          const ChatButton(
            iconSize: BottomBarStyle.iconSize,
          ),
          IconButton(
            icon: const Icon(Icons.menu, size: BottomBarStyle.iconSize),
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
    );
  }
}
