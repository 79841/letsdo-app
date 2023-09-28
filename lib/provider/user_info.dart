import 'package:flutter/material.dart';

class UserData {
  String email;
  String username;
  UserData(this.email, this.username);
}

class UserInfo with ChangeNotifier {
  UserData? _userData;
  UserData? get userData => _userData;

  void setUserData(Map data) {
    _userData = UserData(data["email"], data["username"]);
    notifyListeners();
  }

  void removeUserData() {
    _userData = null;
    notifyListeners();
  }
}
