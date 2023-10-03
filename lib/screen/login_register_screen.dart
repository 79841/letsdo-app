import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/component/input_box.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/provider/user_info.dart';
import 'package:ksica/query/user_info.dart';
import 'package:ksica/utils/email_format_check.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../query/auth.dart';
import '../utils/space.dart';
import 'home_screen.dart';

class LoginScreenStyle {
  static const double logoFontSize = 25.0;
  static const FontWeight logoFontWeight = FontWeight.w500;
  static const double infoFontSize = 17.0;
  static const FontWeight infoFontWeight = FontWeight.w600;
  static const double buttonFontSize = 16.0;
  static const FontWeight buttonFontWeight = FontWeight.w600;
  static const double boxHeight = 50.0;
  static const double boxWidth = 300.0;
  static const double bottomMargin = 20.0;
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
  bool _isValidFormat = true;

  Future<void> signIn(BuildContext context, VoidCallback onSuccess) async {
    final response = await signInWithEmailAndPassword(
        _controllerEmail.text, _controllerPassword.text);

    final token = json.decode(response.body)['Authorization'];
    await storage.write(
      key: "Authorization",
      value: token,
    );
    final userInfo = await getUserInfo();

    if (mounted) {
      Provider.of<Auth>(context, listen: false).setToken(token);
      Provider.of<UserInfo>(context, listen: false).setUserData(userInfo);
    }
    onSuccess.call();
  }

  Widget _logo() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 150.0,
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

  Widget _info(String text) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: LoginScreenStyle.infoFontSize,
          fontWeight: LoginScreenStyle.infoFontWeight,
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      width: LoginScreenStyle.boxWidth,
      height: LoginScreenStyle.boxHeight,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(darkBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () {
          if (!isEmailValid(_controllerEmail.text)) {
            setState(() {
              _isValidFormat = false;
              errorMessage = "잘못된 이메일 형식입니다.";
            });
            return;
          }
          _isValidFormat = true;

          signIn(
            context,
            () {
              context.read<Auth>().authorize();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const HomeScreen(),
                ),
              );
            },
          );
        },
        child: const Text(
          '로그인',
          style: TextStyle(
            fontSize: LoginScreenStyle.buttonFontSize,
            fontWeight: LoginScreenStyle.buttonFontWeight,
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
              borderRadius: BorderRadius.circular(10.0),
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
            fontSize: LoginScreenStyle.buttonFontSize,
            fontWeight: LoginScreenStyle.buttonFontWeight,
          ),
        ),
      ),
    );
  }

  Widget _loginMode(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _info("이메일로 로그인"),
          hspace(LoginScreenStyle.bottomMargin),
          InputBox(
            title: 'email',
            controller: _controllerEmail,
            width: LoginScreenStyle.boxWidth,
            height: LoginScreenStyle.boxHeight,
            isPassword: false,
            isValidFormat: _isValidFormat,
          ),
          hspace(LoginScreenStyle.bottomMargin),
          InputBox(
            title: 'password',
            controller: _controllerPassword,
            width: LoginScreenStyle.boxWidth,
            height: LoginScreenStyle.boxHeight,
            isPassword: true,
          ),
          hspace(LoginScreenStyle.bottomMargin),
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
    return SizedBox(
      width: LoginScreenStyle.boxWidth,
      height: LoginScreenStyle.boxHeight,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(darkBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () async {
          await createUserWithEmailAndPassword(
            _controllerEmail.text,
            _controllerUserName.text,
            _controllerPassword.text,
          );
          _controllerEmail.text = "";
          _controllerPassword.text = "";
          _controllerUserName.text = "";
          setState(() {
            isLogin = true;
          });
        },
        child: const Text(
          "회원가입",
          style: TextStyle(
            color: mainWhite,
            fontSize: LoginScreenStyle.buttonFontSize,
            fontWeight: LoginScreenStyle.buttonFontWeight,
          ),
        ),
      ),
    );
  }

  Widget _changeLoginMode(BuildContext context) {
    return SizedBox(
      width: LoginScreenStyle.boxWidth,
      height: LoginScreenStyle.boxHeight,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(mainBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () {
          setState(
            () {
              isLogin = true;
            },
          );
        },
        child: const Text(
          '로그인',
          style: TextStyle(
            fontSize: LoginScreenStyle.buttonFontSize,
            fontWeight: LoginScreenStyle.buttonFontWeight,
          ),
        ),
      ),
    );
  }

  Widget _registerMode(BuildContext context) {
    return SizedBox(
      width: LoginScreenStyle.boxWidth,
      child: Column(
        children: [
          _info("회원가입"),
          hspace(LoginScreenStyle.bottomMargin),
          const Label(
            text: "email",
            width: LoginScreenStyle.boxWidth,
          ),
          InputBox(
            title: 'email',
            controller: _controllerEmail,
            width: LoginScreenStyle.boxWidth,
            height: LoginScreenStyle.boxHeight,
            isPassword: false,
          ),
          hspace(LoginScreenStyle.bottomMargin),
          const Label(
            text: "username",
            width: LoginScreenStyle.boxWidth,
          ),
          InputBox(
            title: 'username',
            controller: _controllerUserName,
            width: LoginScreenStyle.boxWidth,
            height: LoginScreenStyle.boxHeight,
            isPassword: false,
          ),
          hspace(LoginScreenStyle.bottomMargin),
          const Label(
            text: "password",
            width: LoginScreenStyle.boxWidth,
          ),
          InputBox(
            title: 'password',
            controller: _controllerPassword,
            width: LoginScreenStyle.boxWidth,
            height: LoginScreenStyle.boxHeight,
            isPassword: true,
          ),
          hspace(LoginScreenStyle.bottomMargin),
          _registerButton(context),
          hspace(LoginScreenStyle.bottomMargin),
          _changeLoginMode(context),
        ],
      ),
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
        child: SingleChildScrollView(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
