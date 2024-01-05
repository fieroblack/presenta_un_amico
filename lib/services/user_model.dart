import 'package:flutter/material.dart';

class LoggedInUser extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _lastName = '';
  bool _loggedIn = false;
  bool _admin = false;

  String get email => _email;
  bool get loggedIn => _loggedIn;
  String get name => _name;
  String get lastName => _lastName;
  bool get admin => _admin;

  void setParameter(Map<String, dynamic> map) {
    _name = map['Name'];
    _lastName = map['LastName'];
    _admin = map['Rule'];
    _email = map['Email'];
  }

  void logIn() {
    _loggedIn = true;
    notifyListeners();
  }

  void logOut() {
    _loggedIn = false;
    notifyListeners();
  }
}
