import 'package:flutter/material.dart';

import '../../utilities/constants.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput(
      {super.key,
      required this.label,
      required this.readOnly,
      required this.controller});

  final String label;
  final bool readOnly;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: TextField(
        controller: controller,
        enabled: !readOnly,
        readOnly: readOnly,
        style: kUserPwdTextStyle,
        decoration: InputDecoration(
          label: Text(
            label,
            style: kLabelStyle,
          ),
          hintStyle: kHintTextStyle,
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
