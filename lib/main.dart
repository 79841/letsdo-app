import 'package:flutter/material.dart';
import 'package:ksica/provider/auth.dart';
import 'package:ksica/provider/check_list.dart';
import 'package:ksica/provider/todo_list.dart';
import 'package:ksica/widget_tree.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 기기의 시간대를 가져옵니다.
  // final String timeZone = await FlutterNativeTimezone.getLocalTimezone();

  // 앱의 시간대를 설정합니다.
  // Intl.defaultLocale = 'ko_KR'; // 앱의 로케일 설정 (한국어)
  // await initializeDateFormatting(); // 날짜 및 시간 형식 설정
  // tz.setLocalLocation(tz.getLocation(timeZone));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => TodoList()),
        ChangeNotifierProvider(create: (_) => CheckList()),
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

  // static const MaterialColor white = MaterialColor(
  //   0xFAFAFAFA,
  //   <int, Color>{
  //     50: Color(0xFAFAFAFA),
  //     100: Color(0xFAFAFAFA),
  //     200: Color(0xFAFAFAFA),
  //     300: Color(0xFAFAFAFA),
  //     400: Color(0xFAFAFAFA),
  //     500: Color(0xFAFAFAFA),
  //     600: Color(0xFAFAFAFA),
  //     700: Color(0xFAFAFAFA),
  //     800: Color(0xFAFAFAFA),
  //     900: Color(0xFAFAFAFA),
  //   },
  // );
  static const int _blackPrimaryValue = 0xFF000000;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryBlack,
      ),
      home: const WidgetTree(),
    );
  }
}
