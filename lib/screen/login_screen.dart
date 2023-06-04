import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../provider/auth.dart';

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

  Future<void> signInWithEmailAndPassword(
      BuildContext context, VoidCallback onSuccess) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final url = Uri.parse('http://141.164.51.245:8000/auth/');
    final response = await http.post(url,
        body: json.encode({
          "email": _controllerEmail.text,
          "password": _controllerPassword.text
        }),
        headers: headers);

    await storage.write(
      key: "Authorization",
      value: json.decode(response.body)['Authorization'],
    );
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
        signInWithEmailAndPassword(
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
