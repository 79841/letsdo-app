import 'package:flutter/material.dart';
import 'package:ksica/component/to_do.dart';
import 'package:provider/provider.dart';
import '../Layout/sub_layout.dart';
import '../provider/check_list.dart';
import '../query/check_list.dart';
import '../query/todo_list.dart';

class CheckListScreen extends StatefulWidget {
  const CheckListScreen({super.key});

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  Widget _checkList(todoList, checkStates) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: todoList.map(
            (e) {
              bool isChecked = false;
              for (var v in checkStates) {
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
                future: Future.wait([
                  fetchTodoList(),
                  fetchCheckList(),
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Failed to load data'),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data yet.'));
                  }

                  final todoList = snapshot.data[0];
                  final checkStates = snapshot.data[1];
                  return _checkList(todoList, checkStates);
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
