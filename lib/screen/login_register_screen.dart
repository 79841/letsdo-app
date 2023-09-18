import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/config/style.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../query/auth.dart';
import '../utils/space.dart';

class LoginScreenStyle {
  static const double logoFontSize = 25.0;
  static const FontWeight logoFontWeight = FontWeight.w500;
  static const double infoFontSize = 20.0;
  static const FontWeight infoFontWeight = FontWeight.w500;
  static const double inputFontSize = 15.0;
  static const FontWeight inputFontWeight = FontWeight.w400;
  static const double boxHeight = 50.0;
  static const double boxWidth = 300.0;
}

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
      // margin: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 150.0,
      // margin: const EdgeInsets.all(80.0),
      child: const Text(
        'KSICA',
        style: TextStyle(
          fontSize: LoginScreenStyle.logoFontSize,
          fontWeight: LoginScreenStyle.logoFontWeight,
          color: mainBlack,
        ),
      ),
    );
  }

  Widget _loginInfo() {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        "이메일로 로그인",
        style: TextStyle(
          fontSize: LoginScreenStyle.inputFontSize,
          fontWeight: LoginScreenStyle.inputFontWeight,
        ),
      ),
    );
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return Container(
      color: mainWhite,
      width: LoginScreenStyle.boxWidth,
      height: LoginScreenStyle.boxHeight,
      child: TextField(
        style: const TextStyle(
          fontSize: LoginScreenStyle.inputFontSize,
          color: mainBlack,
        ),
        controller: controller,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          labelText: title,
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 20.0),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      // margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
      // width: MediaQuery.of(context).size.width,
      width: LoginScreenStyle.boxWidth,
      height: LoginScreenStyle.boxHeight,

      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(darkBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 모서리 반지름 설정
            ),
          ),
        ),
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
        child: const Text(
          '로그인',
          style: TextStyle(
            fontSize: LoginScreenStyle.inputFontSize,
          ),
        ),
      ),
    );
  }

  Widget _changeToRegisterMode(BuildContext context) {
    return Container(
      width: LoginScreenStyle.boxWidth,
      height: LoginScreenStyle.boxHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: mainBlue,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(mainBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 모서리 반지름 설정
            ),
          ),
        ),
        onPressed: () {
          setState(
            () {
              isLogin = false;
            },
          );
        },
        child: const Text(
          "회원가입",
          style: TextStyle(
            color: mainWhite,
            fontSize: LoginScreenStyle.inputFontSize,
          ),
        ),
      ),
    );
  }

  Widget _loginMode(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _loginInfo(),
          hspace(LoginScreenStyle.bottomMargin),
          _entryField('email', _controllerEmail),
          hspace(LoginScreenStyle.bottomMargin),
          _entryField('password', _controllerPassword),
          hspace(LoginScreenStyle.bottomMargin),
          // _errorMessage(),
          // hspace(LoginScreenStyle.bottomMargin),
          _loginButton(context),
          hspace(LoginScreenStyle.bottomMargin),
          _changeToRegisterMode(context),
        ],
      ),
    );
  }

  Widget _registerButton(
    BuildContext context,
  ) {
    return Container(
      color: darkBlue,
      width: LoginScreenStyle.boxWidth,
      height: LoginScreenStyle.boxHeight,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 모서리 반지름 설정
            ),
          ),
        ),
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
      backgroundColor: lightBlue,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _logo(),
              _formMode(context),
              // _loginOrRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}
