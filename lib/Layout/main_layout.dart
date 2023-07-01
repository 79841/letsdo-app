import 'package:flutter/material.dart';

import '../screen/chat_screen.dart';

class Layout extends StatelessWidget {
  final child;
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

  void goToChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const ChatScreen(),
      ),
    );
  }
}
