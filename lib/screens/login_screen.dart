import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'components/custom_email_pwd_input.dart';
import 'components/slider_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                'assets/images/iagica_logo.png',
                scale: 8,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomEmPwInput(
                    controller: _email,
                    hintText: 'Username',
                    pwd: false,
                  ),
                  CustomEmPwInput(
                    controller: _pwd,
                    hintText: 'Password',
                    pwd: true,
                  ),
                  SliderSubmit(
                    label: 'Scorri per accedere',
                    func: () async {
                      LoggedInUser user = LoggedInUser(_email.text, _pwd.text);
                      Map<String, dynamic> datas = {};
                      try {
                        var conn = await MySQLServices.connectToMySQL();
                        datas = await MySQLServices.logIn(conn, user);
                        await MySQLServices.connectClose(conn);
                        user.setParameter(datas);
                        user.setLoggedInOut();
                      } catch (e) {
                        if (context.mounted) {
                          FlutterGeneralServices.showSnackBar(
                              context, "Si è verificato un errore, riprova.");
                        }
                      }
                      return user;
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
