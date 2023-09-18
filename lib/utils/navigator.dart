import 'dart:async';

import 'package:flutter/material.dart';

import '../screen/chat_screen.dart';

void goToChat(BuildContext context, int chatroomId,
    FutureOr<dynamic> Function(dynamic) callback) async {
  // Map<String, dynamic> chatroom = await fetchChatroom();
  Navigator.of(context)
      .push(
        MaterialPageRoute(
          builder: (BuildContext context) => ChatScreen(
            chatroomId: chatroomId,
          ),
        ),
      )
      .then(callback);
}
