import 'package:flutter/material.dart';

import '../../utilities/constants.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput(
      {super.key,
      required String label,
      required bool readOnly,
      required TextEditingController controller,
      required bool textCapitalization,
      required TextInputType kType})
      : _kType = kType,
        _textCapitalization = textCapitalization,
        _controller = controller,
        _readOnly = readOnly,
        _label = label;

  final String _label;
  final bool _readOnly;
  final TextEditingController _controller;
  final bool _textCapitalization;
  final TextInputType _kType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: TextField(
        keyboardType: _kType,
        controller: _controller,
        enabled: !_readOnly,
        readOnly: _readOnly,
        textCapitalization: _textCapitalization
            ? TextCapitalization.words
            : TextCapitalization.none,
        style: kUserPwdTextStyle,
        decoration: InputDecoration(
          labelText: _label,
          contentPadding: const EdgeInsets.all(20.0),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: LogoColor.greenLogoColor, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
