import 'package:mysql1/mysql1.dart';

class MySQLServices {
  static const String _host = 'db647.webme.it';
  static const int _port = 3306;
  static const String _user = 'iagica_13';
  static const String _db = 'iagica_13';
  static const String _pwd = 'Ts91mjNp';

  static Future<dynamic> connectToMySQL() async {
    var settings = ConnectionSettings(
        host: _host, port: _port, user: _user, password: _pwd, db: _db);
    try {
      var conn = await MySqlConnection.connect(settings);
      return conn;
    } catch (e) {
      throw Exception('Connection error $e');
    }
  }

  static Future<void> connectClose(var conn) async {
    try {
      await conn.close();
    } catch (e) {
      throw Exception('Cannot close connection: $e');
    }
  }

  static Future<void> appendRow(var conn, String promoter, String name,
      String lastName, String email, String tel, String level) async {
    String query =
        "INSERT INTO candidates (promoter, name, lastName, email, tel, level, date) "
        "VALUES ('$promoter', '$name', '$lastName', '$email', '$tel', '$level', '${DateTime.now()}')";
    try {
      await conn.query(query);
    } catch (e) {
      throw Exception('Cannot insert record: $e');
    }
  }

  static Future selectAll(var conn) async {
    String query = "Select * from candidates order by id";
    dynamic result;
    try {
      result = await conn.query(query);
    } catch (e) {
      throw Exception('Cannot insert record: $e');
    }
    return result;
  }

  static Future<void> deleteByKey(var conn, int id) async {
    String query = "DELETE FROM candidates where id='$id'";
    try {
      await conn.query(query);
    } catch (e) {
      throw Exception('Cannot insert record: $e');
    }
  }
}
