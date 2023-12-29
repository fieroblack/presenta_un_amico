import 'package:flutter/material.dart';

class RowButton extends StatelessWidget {
  const RowButton({
    super.key,
    required dynamic Function() func,
    required String label,
    required String textForButton,
  })  : _textForButton = textForButton,
        _label = label,
        _func = func;

  final Function() _func;
  final String _label;
  final String _textForButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _label,
          style: const TextStyle(color: Colors.black),
        ),
        TextButton(
          onPressed: _func,
          child: Text(
            _textForButton,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
