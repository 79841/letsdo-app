import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ksica/screen/home_screen.dart';
import 'package:provider/provider.dart';

import '../component/chat_button.dart';
import '../component/profile_image.dart';
import '../provider/auth.dart';
import '../screen/profile_screen.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  MainLayout({required this.child, super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> signOut(BuildContext context, VoidCallback onSuccess) async {
    if (!context.mounted) {
      return;
    }
    await HomeScreen.storage.delete(
      key: "Authorization",
    );
    Provider.of<Auth>(context, listen: false).removeToken();
    onSuccess.call();
  }

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
        shadowColor: Colors.transparent,
        // leading: null,
        leading: GestureDetector(
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: const Color(0xFAFAFAFA),

        title: const Text(
          "KSICA",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              child: MouseRegion(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileImage(
                      profileImageSize: 50.0,
                    ),
                    _Profile(),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('홈'),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('프로필'),
              onTap: () => _goToProfile(context),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('메세지'),
              onTap: () {
                // 메뉴 항목 선택 시 수행할 동작
                // 예시: 메시지 화면으로 이동
                Navigator.pop(context);
                // TODO: 메시지 화면으로 이동하는 동작 추가
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('설정'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
              onTap: () {
                signOut(
                  context,
                  () {
                    context.read<Auth>().unauthorize();
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: child,
      floatingActionButton: const ChatButton(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _goToChat(context),
      //   backgroundColor: Colors.grey.shade900,
      //   child: const Icon(Icons.chat_bubble_rounded),
      // ),
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
