import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
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
      throw Exception('Error: $e');
    }
  }

  static Future<void> appendRowCandidates(
      String promoter,
      String name,
      String lastName,
      String email,
      String tel,
      String level,
      String technologies,
      String file) async {
    String query =
        "INSERT INTO candidates (promoter, name, lastName, email, tel, level, technologies, file, date) "
        "VALUES ('$promoter', '$name', '$lastName', '$email', '$tel', '$level', '$technologies', '$file', '${DateTime.now()}')";
    try {
      var conn = await MySQLServices.connectToMySQL();
      var res = await conn.query(query);

      query =
          "INSERT INTO iter (id_candidatura, status) VALUES ('${res.insertId!}', 'closed')";
      await conn.query(query);
      await conn.close();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future genericSelect(String table, {String? param}) async {
    String query = "Select * from $table";
    if (param != null) {
      query = '$query where $param';
    }

    dynamic result;
    try {
      var conn = await MySQLServices.connectToMySQL();
      result = await conn.query(query);
      await conn.close();
    } catch (e) {
      throw Exception('Error: $e');
    }
    return result;
  }

  static Future selectAll({String? promoter}) async {
    String query =
        "Select * from candidates where promoter='$promoter' order by id";
    if (promoter == null) {
      query = "Select * from candidates order by id";
    }

    dynamic result;
    try {
      var conn = await MySQLServices.connectToMySQL();
      result = await conn.query(query);
      await conn.close();
    } catch (e) {
      throw Exception('Error: $e');
    }
    return result;
  }

  static Future<void> deleteByKey(int id) async {
    String query = "DELETE FROM candidates where id='$id'";
    try {
      var conn = await MySQLServices.connectToMySQL();
      await conn.query(query);
      await conn.close();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<dynamic> readPdfFile(int id) async {
    String query = "select file from candidates where id='$id'";
    List<int> byteList = [];
    try {
      var conn = await MySQLServices.connectToMySQL();
      var results = await conn.query(query);
      await conn.close();
      var base64EncodedData = results.first['file'].toString();
      base64EncodedData = base64.normalize(base64EncodedData);
      byteList = base64Decode(base64EncodedData);
    } catch (e) {
      throw Exception('Error: $e');
    }

    return byteList;
  }

  static Future<Map<String, dynamic>> logIn(
      String email, String password) async {
    String query = "SELECT * FROM users where email='$email'";
    Map<String, dynamic> results = {};
    dynamic datas = '';
    try {
      var conn = await MySQLServices.connectToMySQL();
      datas = await conn.query(query);
      await conn.close();
    } catch (e) {
      throw Exception('Error: $e');
    }
    Uint8List data = Uint8List.fromList(utf8.encode(password));
    String hashedPassword = sha256.convert(data).toString();

    if (datas.first['password'] == hashedPassword) {
      results['Name'] = datas.first['name'];
      results['LastName'] = datas.first['lastName'];
      results['Email'] = datas.first['email'];
      if (datas.first['rule'] == 1) {
        results['Rule'] = true;
      } else {
        results['Rule'] = false;
      }
    }
    return results;
  }

  static Future<void> appendRowUsers(String name, String lastName, String email,
      String password, int admin) async {
    String query = "INSERT INTO users (name, lastName, email, password, rule) "
        "VALUES ('$name', '$lastName', '$email', '$password', '$admin')";
    try {
      var conn = await MySQLServices.connectToMySQL();
      await conn.query(query);
      await conn.close();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> appendRowIter(String id) async {
    String query = "INSERT INTO iter (id) "
        "VALUES ('$id')";
    try {
      var conn = await MySQLServices.connectToMySQL();
      await conn.query(query);
      await conn.close();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> manageIter(String parameter, String id) async {
    String query = "UPDATE iter SET $parameter where id_candidatura='$id'";
    try {
      var conn = await MySQLServices.connectToMySQL();
      await conn.query(query);
      await conn.close();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
