import 'package:flutter/material.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/provider/user_info.dart';
import 'package:ksica/screen/home_screen.dart';
import 'package:provider/provider.dart';

import '../component/profile_image.dart';
import '../screen/profile_screen.dart';

class SubLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const SubLayout({this.title = "KSCIA", required this.child, super.key});

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
      appBar: AppBar(
        backgroundColor: lightBlue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(context),
        ),
        shadowColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
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
              onTap: () {},
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
    UserData userData = Provider.of<UserInfo>(context, listen: false).userData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(userData.username),
        Text(userData.email),
      ],
    );
  }
}
