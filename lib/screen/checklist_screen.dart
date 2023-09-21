import 'package:flutter/material.dart';
import 'package:ksica/component/to_do.dart';
import 'package:provider/provider.dart';
import '../Layout/sub_layout.dart';
import '../provider/check_list.dart';
import '../provider/todo_list.dart';
import '../query/check_list.dart';

class CheckListScreen extends StatefulWidget {
  const CheckListScreen({super.key});

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  Future<bool> _initCheckStates() async {
    if (!mounted) return false;
    await Provider.of<TodoList>(context, listen: false).getTodoList();
    await Provider.of<CheckList>(context, listen: false).fetchCheckStates();
    return true;
  }

  Widget _checkList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: SizedBox(
        // width: 350.0,
        // height: 700.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: Provider.of<TodoList>(context, listen: false).todoList.map(
            (e) {
              bool isChecked = false;
              for (var v in Provider.of<CheckList>(context, listen: false)
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
    );
  }

  Widget _SaveButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      width: 350.0,
      child: ElevatedButton(
        onPressed: () => updateCheckList(
            Provider.of<CheckList>(context, listen: false).checkStates),
        child: const Text("save"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubLayout(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 700.0,
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
              _SaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
