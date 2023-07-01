import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/screen/login_register_screen.dart';
import 'package:provider/provider.dart';
import '../Layout/main_layout.dart';
import '../component/page_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../component/check_list_chart.dart';
import '../provider/auth.dart';
import '../query/chatroom.dart';
import 'chat_screen.dart';
import 'checklist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const storage = FlutterSecureStorage();

  Future<void> signOut(BuildContext context, VoidCallback onSuccess) async {
    if (!context.mounted) {
      return;
    }
    await storage.delete(
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen(),
              ),
            );
          },
        );
      },
      child: const Text("Sign Out"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CheckListChart(),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PageButton(
                  icon: Icons.home,
                  onPressed: goToWebSite,
                ),
                PageButton(
                  icon: Icons.check_box,
                  onPressed: () => goToCheckList(context),
                ),
                PageButton(
                  icon: Icons.chat,
                  onPressed: () => goToChat(context),
                ),
              ],
            ),
            _signOutButton(context),
          ],
        ),
      ),
    );
  }

  void goToWebSite() {
    launchUrl(
      Uri.parse('http://www.kscia.org/kscia/'),
    );
  }

  void goToCheckList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const CheckListScreen(),
      ),
    );
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
