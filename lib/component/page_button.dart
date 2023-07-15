import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const PageButton({required this.onPressed, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      width: 80.0,
      height: 100.0,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color?>(Colors.white),
        ),
        onPressed: onPressed,
        child: Icon(
          icon,
          color: Colors.grey.shade500,
          size: 50.0,
        ),
      ),
    );
  }
}
