import 'package:flutter/material.dart';
import 'components/custom_email_pwd_input.dart';
import 'components/row_button.dart';
import 'components/slider_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  const CustomEmPwInput(
                    hintText: 'Username',
                    pwd: false,
                  ),
                  const CustomEmPwInput(
                    hintText: 'Password',
                    pwd: true,
                  ),
                  const SliderSubmit(
                    label: 'Scorri per accedere',
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
