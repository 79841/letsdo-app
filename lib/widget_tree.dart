import 'package:flutter/material.dart';
import 'package:ksica/providers/auth.dart';
import 'package:ksica/screens/home_screen.dart';
import 'package:ksica/screens/token_login_screen.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return context.watch<Auth>().auth
        ? const HomeScreen()
        : const TokenLoginScreen();
  }
}
