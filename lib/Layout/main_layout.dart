import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final child;
  const Layout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: child));
  }
}
