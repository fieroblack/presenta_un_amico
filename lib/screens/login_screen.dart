import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/services/userModel.dart';
import 'components/custom_email_pwd_input.dart';
import 'components/row_button.dart';
import 'components/slider_button.dart';
import 'main_page.dart';

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
                        print(user.loggedIn);
                      } catch (e) {
                        if (context.mounted) {
                          FlutterGeneralServices.showSnackBar(
                              context, "Si è verificato un errore, riprova.");
                        }
                      }
                      if (user.loggedIn) {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(
                                user: user,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  RowButton(
                      label: 'Non sei ancora registrato?',
                      textForButton: 'Fallo subito!',
                      func: () {
                        //TODO capire se la registrazione va lasciata in gestione agli admin
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
