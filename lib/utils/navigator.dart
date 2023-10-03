import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screen/chat_screen.dart';
import '../screen/login_register_screen.dart';
import '../screen/profile_screen.dart';

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

void goToProfile(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) => const ProfileScreen(),
    ),
  );
}

void goToLogin(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ),
  );
}
