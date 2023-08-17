import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../query/check_list.dart';

class CheckList with ChangeNotifier {
  List<dynamic> _checkStates = [];
  List<dynamic> get checkStates => _checkStates;

  Future<void> fetchCheckStates() async {
    _checkStates = await fetchCheckList();
    notifyListeners();
  }

  Future<void> updateCheckStates(int code, bool done) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String todayStr = dateFormat.format(today);

    _checkStates = _checkStates.where((e) => e["code"] != code).toList();
    _checkStates.add({"code": code, "date": todayStr, "done": done});
    notifyListeners();
  }
}
