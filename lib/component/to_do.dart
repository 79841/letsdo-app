import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/check_list.dart';
import '../query/check_list.dart';

class ToDo extends StatefulWidget {
  final Map toDo;
  final bool isChecked;
  const ToDo({required this.toDo, required this.isChecked, super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380.0,
      height: 50.0,
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 7),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 10.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.toDo['name']),
            ToDoCheckBox(
              code: widget.toDo['code'],
              isChecked: widget.isChecked,
            ),
          ],
        ),
      ),
    );
  }
}

class ToDoCheckBox extends StatefulWidget {
  final int code;
  final bool isChecked;
  const ToDoCheckBox({required this.code, required this.isChecked, super.key});

  @override
  State<ToDoCheckBox> createState() => _ToDoCheckBoxState();
}

class _ToDoCheckBoxState extends State<ToDoCheckBox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isChecked = widget.isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) async {
        await Provider.of<CheckList>(context, listen: false)
            .updateCheckStates(widget.code, value ?? false);
        await updateCheckList(
            Provider.of<CheckList>(context, listen: false).checkStates);
        await Provider.of<CheckList>(context, listen: false).fetchCheckStates();
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
