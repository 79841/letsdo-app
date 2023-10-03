import 'package:flutter/material.dart';
import 'package:ksica/component/to_do.dart';
import 'package:ksica/utils/space.dart';
import 'package:provider/provider.dart';
import '../provider/todo_list.dart';
import '../query/check_list.dart';
import '../provider/check_list.dart' as clp;

class CheckListStyle {
  static const double titleFontSize = 16.0;
  static const FontWeight titleFontWeight = FontWeight.w600;
}

class CheckList extends StatefulWidget {
  const CheckList({super.key});

  @override
  State<CheckList> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckList> {
  Future<bool> _initCheckStates() async {
    if (!mounted) return false;
    await Provider.of<TodoList>(context, listen: false).getTodoList();
    await Provider.of<clp.CheckList>(context, listen: false).fetchCheckStates();
    return true;
  }

  Widget _checkList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "할 일",
              style: TextStyle(
                fontSize: CheckListStyle.titleFontSize,
                fontWeight: CheckListStyle.titleFontWeight,
              ),
            ),
          ),
          hspace(15.0),
          Container(
            child: Column(
              children:
                  Provider.of<TodoList>(context, listen: false).todoList.map(
                (e) {
                  bool isChecked = false;
                  for (var v
                      in Provider.of<clp.CheckList>(context, listen: false)
                          .checkStates) {
                    if (e["code"] == v["code"] && v["done"] == true) {
                      isChecked = true;
                    }
                  }
                  return ToDo(
                    toDo: e,
                    isChecked: isChecked,
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _SaveButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      width: 380.0,
      child: ElevatedButton(
        onPressed: () async {
          await updateCheckList(
              Provider.of<clp.CheckList>(context, listen: false).checkStates);
          await Provider.of<clp.CheckList>(context, listen: false)
              .fetchCheckStates();
        },
        child: const Text("save"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _initCheckStates(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return _checkList();
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
