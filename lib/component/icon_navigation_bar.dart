import 'package:flutter/material.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/provider/chatroom.dart';
import 'package:provider/provider.dart';
import '../utils/navigator.dart';

class IconNavigationBarStyle {
  static const double fontSize = 16.0;
  static const double iconSize = 40.0;
}

class _NavigationData {
  final IconData icon;
  final String text;
  final void Function() handlePressed;
  _NavigationData(this.icon, this.text, this.handlePressed);
}

class IconNavigationBar extends StatefulWidget {
  final BuildContext pageContext;
  const IconNavigationBar({required this.pageContext, super.key});

  @override
  State<IconNavigationBar> createState() => _IconNavigationBarState();
}

class _IconNavigationBarState extends State<IconNavigationBar> {
  @override
  Widget build(BuildContext context) {
    List<_NavigationData> navigationInfo = [
      _NavigationData(
        Icons.chat_bubble_outline_outlined,
        "상담하기",
        () => goToChat(
          widget.pageContext,
          Provider.of<Chatroom>(context, listen: false).chatroomId,
          (value) {
            setState(() {});
          },
        ),
      ),
      _NavigationData(Icons.language, "홈페이지", () => goToWebSite()),
      _NavigationData(
          Icons.notifications_none, "공지사항", () => goToWebSiteNotification()),
      _NavigationData(Icons.warning_amber_rounded, "추가", () {}),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          children: navigationInfo.map(
            (_NavigationData data) {
              return IconNavigator(
                icon: data.icon,
                text: data.text,
                handlePressed: data.handlePressed,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class IconNavigator extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() handlePressed;
  const IconNavigator(
      {required this.icon,
      required this.text,
      required this.handlePressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
      width: MediaQuery.of(context).size.width * 0.23,
      height: MediaQuery.of(context).size.width * 0.23,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(mainWhite),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          elevation: const MaterialStatePropertyAll(0),
        ),
        onPressed: handlePressed,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Icon(
                icon,
                color: mainBlack,
                size: IconNavigationBarStyle.iconSize,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                text,
                style: const TextStyle(
                  color: mainBlack,
                  fontSize: IconNavigationBarStyle.fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
