import 'package:flutter/material.dart';
import 'package:ksica/query/chatroom.dart';

import '../screen/chat_screen.dart';

class Layout extends StatelessWidget {
  final Widget child;
  const Layout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToChat(context),
        child: const Text("test"),
      ),
    );
  }

  void goToChat(BuildContext context) async {
    Map<String, dynamic> chatroom = await fetchChatroom();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChatScreen(
          chatroomId: chatroom["chatroom_id"],
        ),
      ),
    );
  }
}
