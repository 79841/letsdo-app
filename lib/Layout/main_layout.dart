import 'package:flutter/material.dart';
import 'package:ksica/screen/home_screen.dart';

class Layout extends StatelessWidget {
  final Widget child;
  const Layout({required this.child, super.key});

  void goToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // elevation: 0.0,
        automaticallyImplyLeading: false,
        title: TextButton(
          onPressed: () => goToHome(context),
          child: const Text(
            "KSICA",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      body: child,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => goToChat(context),
      //   child: const Icon(
      //     Icons.chat_bubble_rounded,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
