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
  final TextEditingController _controllerUserName = TextEditingController();

  Future<void> signIn(BuildContext context, VoidCallback onSuccess) async {
    final response = await signInWithEmailAndPassword(
        _controllerEmail.text, _controllerPassword.text);

    print(response.body);

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

  Widget _logo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
      alignment: Alignment.center,
      // margin: const EdgeInsets.all(80.0),
      child: Text(
        'KSICA',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
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

  Widget _loginButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          signIn(
            context,
            () {
              // if (!mounted) return;
              context.read<Auth>().authorize();
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => const HomeScreen(),
              //   ),
              // );
            },
          );
        },
        child: const Text('Login'),
      ),
    );
  }

  Widget _changeToRegisterMode(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          setState(() {
            isLogin = false;
          });
        },
        child: const Text(
          "Go to register",
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _loginMode(BuildContext context) {
    return Column(
      children: [
        _entryField('email', _controllerEmail),
        _entryField('password', _controllerPassword),
        _errorMessage(),
        _loginButton(context),
        _changeToRegisterMode(context),
      ],
    );
  }

  Widget _registerButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
      child: ElevatedButton(
        onPressed: () async {
          await createUserWithEmailAndPassword(
            _controllerEmail.text,
            _controllerUserName.text,
            _controllerPassword.text,
          );
          setState(() {
            isLogin = true;
          });
        },
        child: const Text('Register'),
      ),
    );
  }

  Widget _registerMode(BuildContext context) {
    return Column(
      children: [
        _entryField('email', _controllerEmail),
        _entryField('username', _controllerUserName),
        _entryField('password', _controllerPassword),
        _errorMessage(),
        _registerButton(context),
      ],
    );
  }

  Widget _formMode(BuildContext context) {
    return isLogin ? _loginMode(context) : _registerMode(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Container(
            alignment: Alignment.center,
            height: 700.0,
            width: 300.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _logo(),
                _formMode(context),
                // _loginOrRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
