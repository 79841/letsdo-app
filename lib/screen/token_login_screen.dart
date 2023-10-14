import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../component/dialog/loading_dialog.dart';
import '../provider/auth.dart';
import '../provider/user_info.dart';
import '../query/auth.dart';
import '../query/user_info.dart';
import '../utils/navigator.dart';
import 'home_screen.dart';

class TokenLoginScreen extends StatelessWidget {
  const TokenLoginScreen({super.key});

  static const storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: signInWithToken(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Timer(const Duration(seconds: 1), () => goToLogin(context));
        } else if (snapshot.hasData) {
          Timer(const Duration(seconds: 1), () async {
            final token = snapshot.data!["Authorization"];
            await storage.write(
              key: "Authorization",
              value: token,
            );

            final userInfo = await getUserInfo();

            if (context.mounted) {
              Provider.of<Auth>(context, listen: false).setToken(token);
              Provider.of<UserInfo>(context, listen: false)
                  .setUserData(userInfo);
            }

            context.read<Auth>().authorize();

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen(),
              ),
            );
          });
        }

        return const LoadingDialog(text: "로그인 진행 중 입니다.");
      },
    );
  }
}
