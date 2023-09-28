import 'package:flutter/material.dart';
import 'package:ksica/screen/login_register_screen.dart';

import '../query/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Widget _title() {
    return const Text('Sign Up');
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

  void _goToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
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
          _goToLogin(context);
        },
        child: const Text('Register'),
      ),
    );
  }

  Widget _logo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
      alignment: Alignment.center,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 700.0,
            width: 300.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _logo(),
                _entryField('email', _controllerEmail),
                _entryField('username', _controllerUserName),
                _entryField('password', _controllerPassword),
                _errorMessage(),
                _submitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
