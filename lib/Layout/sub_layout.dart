import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ksica/screen/home_screen.dart';
import 'package:provider/provider.dart';

import '../component/profile_image.dart';
import '../provider/auth.dart';
import '../screen/profile_screen.dart';

class SubLayout extends StatelessWidget {
  final Widget child;
  SubLayout({required this.child, super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _goToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const HomeScreen(),
      ),
    );
  }

  void _goToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shadowColor: Colors.transparent,
        title: const Text(
          "KSICA",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFAFAFAFA),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              // decoration: BoxDecoration(
              //   color: Colors.grey.shade300,
              // ),
              child: MouseRegion(
                child: GestureDetector(
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileImage(
                        profileImageSize: 50.0,
                      ),
                      _Profile(),
                    ],
                  ),
                  onTap: () => _goToProfile(context),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('홈'),
              onTap: () => _goToHome(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('설정'),
              onTap: () {
                // 설정 메뉴 선택 시 수행할 동작
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> token = JwtDecoder.decode(
      Provider.of<Auth>(
        context,
        listen: false,
      ).token,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(token["username"]),
        Text(token["email"]),
      ],
    );
  }
}
