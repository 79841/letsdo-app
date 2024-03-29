import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/chat_screen.dart';
import '../screens/login_register_screen.dart';
import '../screens/profile_screen.dart';

void goToChat(BuildContext context, int? chatroomId,
    FutureOr<dynamic> Function(dynamic) callback) async {
  if (chatroomId == null) {
    return;
  }
  Navigator.of(context)
      .push(
        MaterialPageRoute(
          builder: (BuildContext context) => const ChatScreen(),
        ),
      )
      .then((value) => callback(value));
}

void goToWebSite() {
  launchUrl(
    Uri.parse('http://www.kscia.org/kscia/'),
  );
}

void goToWebSiteNotification() {
  launchUrl(
    Uri.parse(
        'http://www.kscia.org/kscia/bbs/board.php?bo_table=bo_01&sca=%EA%B3%B5%EA%B3%A0'),
  );
}

void goToProfile(BuildContext context, FutureOr<dynamic> Function() callback) {
  Navigator.of(context)
      .push(
        MaterialPageRoute(
          builder: (BuildContext context) => const ProfileScreen(),
        ),
      )
      .then((value) => callback());
}

void goToLogin(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ),
  );
}

void goToTodoList(GlobalKey targetKey, ScrollController controller) {
  final targetPosition =
      targetKey.currentContext!.findRenderObject() as RenderBox;
  final position = targetPosition.localToGlobal(Offset.zero);
  controller.animateTo(
    position.dy,
    duration: const Duration(milliseconds: 600),
    curve: Curves.linear,
  );
}
