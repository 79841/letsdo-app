import 'package:flutter/material.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/provider/auth.dart';
import 'package:ksica/provider/chatroom.dart';
import 'package:ksica/provider/check_list.dart';
import 'package:ksica/provider/todo_list.dart';
import 'package:ksica/provider/user_info.dart';
import 'package:ksica/widget_tree.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => TodoList()),
        ChangeNotifierProvider(create: (_) => CheckList()),
        ChangeNotifierProvider(create: (_) => Chatroom()),
        ChangeNotifierProvider(create: (_) => UserInfo()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const MaterialColor primaryBlack = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  static const int _blackPrimaryValue = 0xFF000000;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: darkBlue,
        unselectedWidgetColor: Colors.white,
      ),
      home: const WidgetTree(),
    );
  }
}
