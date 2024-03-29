import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/components/bar/icon_navigation_bar.dart';
import 'package:ksica/utils/space.dart';
import 'package:provider/provider.dart';
import '../layouts/main_layout.dart';
import '../components/checklist/check_list.dart';
import '../components/chart/check_list_week_chart.dart';
import '../components/chart/check_list_today_chart.dart';
import '../providers/auth.dart';
import '../providers/todo_list.dart';
import 'chat_screen.dart';
import 'checklist_screen.dart';
import '../providers/check_list.dart' as clp;

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
                    targetKey: targetKey,
                    controller: _controller,
                    pageContext: context,
                  ),
                  hspace(40.0),
                  CheckList(targetKey: targetKey),
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
