import 'package:flutter/material.dart';
import 'package:ksica/component/bottom_bar.dart';
import 'package:ksica/component/dialog/loading_dialog.dart';
import 'package:ksica/component/dialog/retry_dialog.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/provider/user_info.dart';
import 'package:ksica/query/chatroom.dart';
import 'package:ksica/screen/home_screen.dart';
import 'package:ksica/utils/fetch_with_retry.dart';
import 'package:ksica/utils/navigator.dart';
import 'package:provider/provider.dart';

import '../component/profile_image.dart';
import '../provider/auth.dart';
import '../provider/chatroom.dart';
import '../screen/login_register_screen.dart';
import '../screen/profile_screen.dart';

class MainLayoutStyle {
  static const Color bgColor = Color(0xffE6EDF6);
  static const Color appBarTitleColor = Color(0xff0d0e0e);
  static const double usernameFontSize = 20.0;
  static const double emailFontSize = 15.0;
  static const double drawerHeaderFontSize = 20.0;
  static const FontWeight usernameFontWeight = FontWeight.w500;
  static const FontWeight emailFontWeight = FontWeight.w300;
  static const double profileHeight = 50.0;
  static const double profileImageSize = 50.0;
  static const double drawerHeaderHeight = 170.0;
  static const FontWeight drawerHeaderFontWeight = FontWeight.w500;
}

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({required this.child, super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool isDialogShowing = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> signOut(BuildContext context, VoidCallback onSuccess) async {
    await HomeScreen.storage.delete(
      key: "Authorization",
    );
    if (context.mounted) {
      Provider.of<Auth>(context, listen: false).removeToken();
      Provider.of<UserInfo>(context, listen: false).removeUserData();
    }

    onSuccess.call();
  }

  // void _goToHome(BuildContext context) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (BuildContext context) => const HomeScreen(),
  //     ),
  //   );
  // }

  void _goToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const ProfileScreen(),
      ),
    );
  }

  Future<void> getChatroomId(BuildContext context) async {
    Map<String, dynamic> chatroom = await fetchChatroom();

    if (!chatroom.containsKey("chatroom_id")) {
      chatroom = await createChatroom();
      Provider.of<Chatroom>(context, listen: false)
          .setChatroomId(chatroom["id"]);
    } else {
      Provider.of<Chatroom>(context, listen: false)
          .setChatroomId(chatroom["chatroom_id"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWithRetry(() async => await getChatroomId(context), 2),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingDialog(text: "데이터를 불러오는 중 입니다.");
        }
        if (snapshot.hasError) {
          return ReloadDialog(
            text: "데이터를 불러오는데 실패했습니다.",
            reload: () {
              setState(() {});
            },
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              Container(),
            ],
            backgroundColor: MainLayoutStyle.bgColor,
            title: const Text(
              "KSICA",
              style: TextStyle(
                color: MainLayoutStyle.appBarTitleColor,
                fontSize: 25.0,
              ),
            ),
            centerTitle: true,
          ),
          endDrawer: Drawer(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: MainLayoutStyle.drawerHeaderHeight,
                  child: DrawerHeader(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "KSCIA",
                            style: TextStyle(
                                fontSize: MainLayoutStyle.drawerHeaderFontSize,
                                fontWeight:
                                    MainLayoutStyle.drawerHeaderFontWeight),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => goToProfile(context, () {
                            setState(() {});
                          }),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ProfileImage(
                                profileImageSize:
                                    MainLayoutStyle.profileImageSize,
                              ),
                              _Profile(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  trailing: const Icon(
                    Icons.link,
                    color: mainBlack,
                  ),
                  title: const Text(
                    '홈페이지 방문하기',
                    style: TextStyle(
                      color: mainBlack,
                    ),
                  ),
                  onTap: () {
                    _scaffoldKey.currentState?.closeDrawer();
                  },
                ),
                ListTile(
                  trailing: const Icon(
                    Icons.link,
                    color: mainBlack,
                  ),
                  title: const Text(
                    '공지사항',
                    style: TextStyle(
                      color: mainBlack,
                    ),
                  ),
                  onTap: () => _goToProfile(context),
                ),
                ListTile(
                  trailing: const Icon(
                    Icons.chat_bubble_outline,
                    color: mainBlack,
                  ),
                  title: const Text(
                    '상담하기',
                    style: TextStyle(
                      color: mainBlack,
                    ),
                  ),
                  onTap: () => goToChat(context,
                      Provider.of<Chatroom>(context, listen: false).chatroomId,
                      (value) {
                    setState(() {});
                  }),
                ),
                ListTile(
                  trailing: const Icon(
                    Icons.logout,
                    color: mainBlack,
                  ),
                  title: const Text(
                    '로그아웃',
                    style: TextStyle(
                      color: mainBlack,
                    ),
                  ),
                  onTap: () {
                    signOut(
                      context,
                      () {
                        context.read<Auth>().unauthorize();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          backgroundColor: MainLayoutStyle.bgColor,
          body: widget.child,
          bottomNavigationBar: BottomBar(
            scaffoldKey: _scaffoldKey,
          ),
        );
      },
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile();

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserInfo>(context, listen: false).userData!;

    return Container(
      margin: const EdgeInsets.all(20.0),
      height: MainLayoutStyle.profileHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            userData.username,
            style: const TextStyle(
              color: mainBlack,
              fontSize: MainLayoutStyle.usernameFontSize,
              fontWeight: MainLayoutStyle.usernameFontWeight,
            ),
          ),
          Text(
            userData.email,
            style: const TextStyle(
              color: mainBlack,
              fontSize: MainLayoutStyle.emailFontSize,
              fontWeight: MainLayoutStyle.emailFontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
