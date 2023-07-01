import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../query/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool isLogin = true;

  static const storage = FlutterSecureStorage();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signIn(BuildContext context, VoidCallback onSuccess) async {
    final response = await signInWithEmailAndPassword(
        _controllerEmail.text, _controllerPassword.text);

    final token = json.decode(response.body)['Authorization'];
    await storage.write(
      key: "Authorization",
      value: token,
    );
    if (mounted) {
      Provider.of<Auth>(context, listen: false).setToken(token);
    }
    onSuccess.call();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        signIn(
          context,
          () {
            if (!mounted) return;
            context.read<Auth>().authorize();
          },
        );
      },
      child: const Text('Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassword),
            _errorMessage(),
            _submitButton(context),
            // _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
