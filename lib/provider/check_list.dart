import 'package:flutter/material.dart';

import '../query/check_list.dart';

class CheckList with ChangeNotifier {
  List<dynamic> _checkStates = [];
  List<dynamic> get checkStates => _checkStates;

  Future<void> fetchCheckStates() async {
    _checkStates = await fetchCheckList();
    notifyListeners();
  }

  Future<void> updateCheckStates(int code, bool done) async {
    _checkStates = _checkStates.where((e) => e["code"] != code).toList();
    _checkStates.add({"code": code, "done": done});
    notifyListeners();
  }
}
