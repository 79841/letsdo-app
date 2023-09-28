import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  bool _auth = false;
  bool get auth => _auth;

  String _token = "";
  String get token => _token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void removeToken() {
    _token = "";
    notifyListeners();
  }

  void authorize() {
    _auth = true;
    notifyListeners();
  }

  void unauthorize() {
    _auth = false;
    notifyListeners();
  }
}
