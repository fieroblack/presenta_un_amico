import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/custom_email_pwd_input.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import '../../utilities/constants.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key, required LoggedInUser user}) : _user = user;

  final LoggedInUser _user;

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  //TODO implementare gestione account

  late Future<List<Widget>> _listFuture;
  late String _selectedValue;

  final List<TextEditingController> _fieldController =
      List.generate(3, (index) => TextEditingController());

  @override
  void initState() {
    _listFuture = _recoverData();

    super.initState();
  }

  Future<List<Widget>> _recoverData() async {
    List<Widget> listWidget = [];
    List<DropdownMenuItem<String>> listItem = [];

    dynamic result;
    try {
      var conn = await MySQLServices.connectToMySQL();
      if (widget._user.admin) {
        result = await MySQLServices.selectAllUsers(
          conn,
        );
      } else {
        result =
            await MySQLServices.selectAllUsers(conn, email: widget._user.email);
      }
      await MySQLServices.connectClose(conn);
    } catch (e) {
      throw Exception('Error: $e');
    }

    for (var i in result) {
      listItem.add(
        DropdownMenuItem(
          value: i['email'],
          child: Text(i['email']),
        ),
      );
    }
    _selectedValue = widget._user.email;

    listWidget.add(DropdownButton<String>(
      value: widget._user.email,
      onChanged: (String? value) {
        setState(() {
          _selectedValue = value!;
        });
      },
      items: listItem,
    ));

    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _listFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: LogoColor.greenLogoColor,
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Elenco vuoto',
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Errore: ${snapshot.error}'),
            );
          } else {
            List<Widget> data = snapshot.data as List<Widget>;
            return Column(
              children: [
                data.first,
                CustomEmPwInput(
                    hintText: 'Password corrente',
                    pwd: true,
                    controller: _fieldController[0]),
                CustomEmPwInput(
                    hintText: 'Nuova password',
                    pwd: true,
                    controller: _fieldController[1]),
                CustomEmPwInput(
                    hintText: 'Conferma password',
                    pwd: true,
                    controller: _fieldController[2]),
                if (widget._user.admin)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LogoColor.redLogoColor,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Elimina utente',
                        style: kButtonStyle,
                      ),
                    ),
                  ),
              ],
            );
          }
        });
  }
}
