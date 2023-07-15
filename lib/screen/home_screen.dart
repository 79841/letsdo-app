import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/component/floating_box.dart';
import 'package:provider/provider.dart';
import '../Layout/main_layout.dart';
import '../component/check_list.dart';
import '../component/check_list_week_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../component/check_list_today_chart.dart';
import '../provider/auth.dart';
import '../provider/todo_list.dart';
import '../query/chatroom.dart';
import 'chat_screen.dart';
import 'checklist_screen.dart';
import '../provider/check_list.dart' as clp;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const storage = FlutterSecureStorage();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        signOut(
          context,
          () {
            context.read<Auth>().unauthorize();
          },
        );
      },
      child: const Text("Sign Out"),
    );
  }

  Widget _hSpace(double height) {
    return SizedBox(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: FutureBuilder<List<dynamic>>(
            future: Future.wait([
              Provider.of<clp.CheckList>(context, listen: false)
                  .fetchCheckStates(),
              Provider.of<TodoList>(context, listen: false).getTodoList()
            ]),
            builder: (context, snapshot) {
              return Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                          alignment: Alignment.centerLeft,
                          child: const Text("Today"),
                        ),
                        const FloatingBox(
                          // alignment: Alignment.center,
                          height: 230.0,
                          width: 380.0,
                          child: CheckListTodayChart(),
                        ),
                      ],
                    ),
                    _hSpace(60.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                          alignment: Alignment.centerLeft,
                          child: const Text("Week"),
                        ),
                        const FloatingBox(
                          height: 200.0,
                          width: 380.0,
                          child: CheckListWeekGraph(),
                        ),
                      ],
                    ),
                    _hSpace(60.0),
                    Column(
                      children: <Widget>[
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                          alignment: Alignment.centerLeft,
                          child: const Text("Check List"),
                        ),
                        const CheckList(),
                      ],
                    ),
                    _hSpace(60.0),
                    // Row(
                    //   // crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     PageButton(
                    //       icon: Icons.home,
                    //       onPressed: goToWebSite,
                    //     ),
                    //     PageButton(
                    //       icon: Icons.check_box,
                    //       onPressed: () => goToCheckList(context),
                    //     ),
                    //     PageButton(
                    //       icon: Icons.chat,
                    //       onPressed: () => goToChat(context),
                    //     ),
                    //   ],
                    // ),
                    // _signOutButton(context),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void goToWebSite() {
    launchUrl(
      Uri.parse('http://www.kscia.org/kscia/'),
    );
  }

  void goToCheckList(BuildContext context) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (BuildContext context) => const CheckListScreen(),
      ),
    )
        .then((value) {
      setState(() {});
    });
  }

  void goToChat(BuildContext context) async {
    Map<String, dynamic> chatroom = await fetchChatroom();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChatScreen(
          chatroomId: chatroom["chatroom_id"],
        ),
      ),
    );
  }
}
