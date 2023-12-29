import 'package:flutter/material.dart';
import 'package:presenta_un_amico/utilities/constants.dart';

class CustomEmPwInput extends StatefulWidget {
  const CustomEmPwInput({
    super.key,
    required String hintText,
    required bool pwd,
  })  : _pwd = pwd,
        _hintText = hintText;

  final String _hintText;
  final bool _pwd;

  @override
  State<CustomEmPwInput> createState() => _CustomEmPwInputState();
}

class _CustomEmPwInputState extends State<CustomEmPwInput> {
  bool _isVisible = false;
  IconData _suffixIcon = Icons.email;

  @override
  void initState() {
    if (widget._pwd) {
      _isVisible = true;
      _suffixIcon = Icons.visibility_off;
    }
    super.initState();
  }

  void _setVisibility() {
    if (!widget._pwd) {
      return;
    }
    setState(() {
      _isVisible = !_isVisible;
      _isVisible
          ? _suffixIcon = Icons.visibility_off
          : _suffixIcon = Icons.visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: TextField(
        style: kUserPwdTextStyle,
        obscureText: _isVisible,
        keyboardType: widget._pwd
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(_suffixIcon),
            onPressed: () {
              _setVisibility();
            },
          ),
          labelText: widget._hintText,
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
