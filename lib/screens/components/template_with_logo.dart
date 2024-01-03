import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/login_screen.dart';
import 'package:presenta_un_amico/screens/pass_reset.dart';
import 'package:presenta_un_amico/services/user_model.dart';

class LogoTemplate extends StatelessWidget {
  const LogoTemplate({
    super.key,
    required List<Widget> listWidget,
    required LoggedInUser user,
  })  : _user = user,
        _listWidget = listWidget;

  final List<Widget> _listWidget;
  final LoggedInUser _user;

  List<Widget> buildScreen(List<Widget> list) {
    List<Widget> list = [];

    list.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/iagica_logo.png',
            scale: 12,
          ),
          PopupMenuButton(
            iconSize: 30.0,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ResetPassword();
                    },
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Resetta password'),
                    Icon(Icons.password),
                  ],
                ),
              ),
              if (_user.admin)
                PopupMenuItem<String>(
                  onTap: () {
                    print('aggiungi un utente');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gestione utenti'),
                      Icon(Icons.manage_accounts),
                    ],
                  ),
                ),
              PopupMenuItem<String>(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Esci'),
                    Icon(Icons.logout),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    list.addAll(_listWidget);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildScreen(_listWidget),
      ),
    );
  }
}
