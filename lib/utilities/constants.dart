import 'package:flutter/material.dart';

class LogoColor {
  static const Color _kRedLogoColor = Color(0xffE32D3A);
  static const Color _kGreenLogoColor = Color(0xff3EFB00);

  static Color get redLogoColor => _kRedLogoColor;
  static Color get greenLogoColor => _kGreenLogoColor;
}

final TextStyle kHintTextStyle = TextStyle(
  fontFamily: 'PlayfairDisplay',
  fontSize: 20.0,
  color: Colors.grey[700],
);

const TextStyle kUserPwdTextStyle = TextStyle(
  fontFamily: 'PlayfairDisplay',
  fontSize: 20.0,
  color: Colors.black,
);

const TextStyle kLabelStyle = TextStyle(
  fontFamily: 'PlayfairDisplay',
  fontSize: 20.0,
  color: Colors.black,
);

const TextStyle kTitleStyle = TextStyle(
  fontSize: 35.0,
  fontFamily: 'PlayfairDisplay',
  color: Colors.black,
);

const TextStyle kButtonStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 25.0,
);

const TextStyle kSnackStyle = TextStyle(
  color: Colors.black,
  fontSize: 15.0,
);
