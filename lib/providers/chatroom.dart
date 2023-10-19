import 'package:flutter/material.dart';

class Chatroom with ChangeNotifier {
  int? _chatroomId;
  int? get chatroomId => _chatroomId;

  void setChatroomId(int chatroomId) {
    _chatroomId = chatroomId;
    notifyListeners();
  }

  void removeChatroomId() {
    _chatroomId = null;
    notifyListeners();
  }
}
