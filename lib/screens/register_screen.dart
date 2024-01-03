import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/slider_button.dart';
import 'components/custom_email_pwd_input.dart';
import 'components/row_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                  // const CustomEmPwInput(
                  //   hintText: 'Username',
                  //   pwd: false,
                  // ),
                  // const CustomEmPwInput(
                  //   hintText: 'Password',
                  //   pwd: true,
                  // ),
                  // const CustomEmPwInput(
                  //   hintText: 'Confirm password',
                  //   pwd: true,
                  // ),
                  // const SliderSubmit(label: 'Scorri per registrarti'),
                  const SizedBox(
                    height: 30.0,
                  ),
                  RowButton(
                    label: 'Sei già registrato?',
                    textForButton: 'Effettua il login!',
                    func: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
