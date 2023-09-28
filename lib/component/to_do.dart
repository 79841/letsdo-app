import 'package:flutter/material.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/utils/space.dart';
import 'package:provider/provider.dart';

import '../provider/check_list.dart';
import '../query/check_list.dart';

class ToDoStyle {
  static const double todoListFontSize = 15.0;
  static const FontWeight todoListFontWeight = FontWeight.w400;
}

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
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15.0),
      child: Row(
        children: [
          ToDoCheckBox(
            code: widget.toDo['code'],
            isChecked: widget.isChecked,
          ),
          wspace(20.0),
          Text(
            widget.toDo['name'],
            style: const TextStyle(
              color: mainBlack,
              fontSize: ToDoStyle.todoListFontSize,
              fontWeight: ToDoStyle.todoListFontWeight,
            ),
          ),
        ],
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
      return darkBlue;
    }

    return Container(
      alignment: Alignment.centerLeft,
      width: 18.0,
      height: 18.0,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        color: mainWhite,
      ),
      child: Checkbox(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        fillColor: isChecked
            ? MaterialStateProperty.all(darkBlue)
            : MaterialStateProperty.all(mainWhite),
        visualDensity: VisualDensity.standard,
        value: isChecked,
        onChanged: (bool? value) async {
          await Provider.of<CheckList>(context, listen: false)
              .updateCheckStates(widget.code, value ?? false);
          await updateCheckList(
              Provider.of<CheckList>(context, listen: false).checkStates);
          await Provider.of<CheckList>(context, listen: false)
              .fetchCheckStates();
          setState(() {
            isChecked = value!;
          });
        },
      ),
    );
  }
}
