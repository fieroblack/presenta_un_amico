import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/account_setting.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'package:provider/provider.dart';

class LogoTemplate extends StatelessWidget {
  const LogoTemplate({
    super.key,
    required this.listWidget,
  });

  final List<Widget> listWidget;

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
                      return AccountSetting();
                    },
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gestione account'),
                    Icon(Icons.manage_accounts),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                onTap: () {
                  Provider.of<LoggedInUser>(context, listen: false).logOut();
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

    list.addAll(listWidget);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildScreen(listWidget),
      ),
    );
  }
}
