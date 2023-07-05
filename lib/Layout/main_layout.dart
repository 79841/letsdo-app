import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ksica/screen/home_screen.dart';

import '../query/profile.dart';

class Layout extends StatelessWidget {
  final Widget child;
  Layout({required this.child, super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void goToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // elevation: 0.0,
        automaticallyImplyLeading: false,

        title: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: const Text(
            "KSICA",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                children: [
                  const Text(
                    "Menu",
                    // style: TextStyle(color: Colors.white),
                  ),
                  FutureBuilder<Uint8List>(
                    future: fetchProfileImage(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: 150.0,
                          height: 150.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.black,
                          ),
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            color: Colors.blue,
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('홈'),
              onTap: () {
                // 홈 메뉴 선택 시 수행할 동작
              },
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => goToChat(context),
      //   child: const Icon(
      //     Icons.chat_bubble_rounded,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
