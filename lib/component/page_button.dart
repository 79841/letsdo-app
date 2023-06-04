import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PageButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.15,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text("hello"),
      ),
    );
  }
}
