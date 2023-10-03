import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/component/icon_navigation_bar.dart';
import 'package:ksica/utils/space.dart';
import 'package:provider/provider.dart';
import '../Layout/main_layout.dart';
import '../component/check_list.dart';
import '../component/check_list_week_chart.dart';
import '../component/check_list_today_chart.dart';
import '../provider/auth.dart';
import '../provider/todo_list.dart';
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
  final GlobalKey targetKey = GlobalKey();
  final ScrollController _controller = ScrollController();

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
        controller: _controller,
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            Provider.of<clp.CheckList>(context, listen: false)
                .fetchCheckStates(),
            Provider.of<TodoList>(context, listen: false).getTodoList()
          ]),
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  hspace(10.0),
                  CheckListTodayChart(
                    targetKey: targetKey,
                    controller: _controller,
                  ),
                  hspace(40.0),
                  const CheckListWeekGraph(),
                  hspace(40.0),
                  IconNavigationBar(
                    pageContext: context,
                  ),
                  hspace(40.0),
                  const CheckList(),
                  hspace(60.0),
                ],
              ),
            );
          },
        ),
      ),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const ChatScreen(),
      ),
    );
  }
}
