import 'package:flutter/material.dart';

class ToDo extends StatelessWidget {
  final Map toDo;
  const ToDo({required this.toDo, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 50.0,
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
          children: const [
            Text("hello"),
            ToDoCheckBox(),
          ],
        ),
      ),
    );
  }
}

class ToDoCheckBox extends StatefulWidget {
  const ToDoCheckBox({super.key});

  @override
  State<ToDoCheckBox> createState() => _ToDoCheckBoxState();
}

class _ToDoCheckBoxState extends State<ToDoCheckBox> {
  bool isChecked = false;

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
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
