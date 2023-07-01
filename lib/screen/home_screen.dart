import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../Layout/main_layout.dart';
import '../component/page_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/auth.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PageButton(
                  onPressed: goToWebSite,
                ),
                PageButton(
                  onPressed: () => goToCheckList(context),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PageButton(
                  onPressed: () {},
                ),
                PageButton(
                  onPressed: () {},
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
}
