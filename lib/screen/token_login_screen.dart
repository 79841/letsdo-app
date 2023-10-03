import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/utils/space.dart';
import 'package:provider/provider.dart';

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

        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: lightBlue,
            child: Container(
              alignment: Alignment.center,
              height: 100.0,
              width: 200.0,
              child: Column(
                children: [
                  const Text(
                    "로그인 진행 중",
                    style: TextStyle(
                      color: mainBlack,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  hspace(10.0),
                  const SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
