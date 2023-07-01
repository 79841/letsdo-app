import 'dart:async';

import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  final StreamController<bool> _auth = StreamController<bool>();
  StreamController<bool> get auth => _auth;
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
    _auth.add(true);
    notifyListeners();
  }

  void unauthorize() {
    _auth.add(false);
    notifyListeners();
  }
}
