import 'package:flutter/material.dart';
import 'package:ksica/provider/auth.dart';
import 'package:ksica/screen/home_screen.dart';
import 'package:ksica/screen/login_register_screen.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //   stream: context.watch<Auth>().auth.stream,
    //   builder: (context, snapshot) {
    //     if (snapshot.data == true) {
    //       return const HomeScreen();
    //     } else {
    //       return const LoginScreen();
    //     }
    //   },
    // );
    // return Consumer<Auth>(
    //   builder: (context, auth, child) {
    //     if (auth.auth == true) {
    //       return const HomeScreen();
    //     } else {
    //       return const LoginScreen();
    //     }
    //   },
    // );
    return context.watch<Auth>().auth
        ? const HomeScreen()
        : const LoginScreen();
  }
}
