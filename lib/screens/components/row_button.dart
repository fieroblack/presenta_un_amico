import 'package:flutter/material.dart';

class RowButton extends StatelessWidget {
  const RowButton({
    super.key,
    required this.func,
    required this.label,
    required this.textForButton,
  });

  final Function() func;
  final String label;
  final String textForButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        TextButton(
          onPressed: func,
          child: Text(
            textForButton,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
