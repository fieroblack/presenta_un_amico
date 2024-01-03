import 'package:presenta_un_amico/services/mysql-services.dart';

class LoggedInUser {
  LoggedInUser(this._email, this._password);

  final String _email;
  String _name = '';
  String _lastName = '';
  final String _password;
  bool _loggedIn = false;
  bool _admin = false;

  bool get loggedIn => _loggedIn;
  String get email => _email;
  String get password => _password;
  String get name => _name;
  String get lastName => _lastName;
  bool get admin => _admin;

  void setParameter(Map<String, dynamic> map) {
    _name = map['Name'];
    _lastName = map['LastName'];
    _admin = map['Rule'];
  }

  void setLoggedInOut() {
    _loggedIn = !_loggedIn;
  }
}
