import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/custom_email_pwd_input.dart';

import '../utilities/constants.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final List<TextEditingController> _fieldsControl =
      List.generate(3, (index) => TextEditingController());

  Future<void> resetPassword(BuildContext context) async {
    //TODO implementare metodo per reset password
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomEmPwInput(
              hintText: 'Password attuale',
              pwd: true,
              controller: _fieldsControl[0],
            ),
            CustomEmPwInput(
              hintText: 'Nuova password',
              pwd: true,
              controller: _fieldsControl[1],
            ),
            CustomEmPwInput(
              hintText: 'Ripeti password',
              pwd: true,
              controller: _fieldsControl[2],
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: LogoColor.greenLogoColor,
                ),
                onPressed: () {
                  resetPassword(context);
                },
                child: const Text(
                  'Conferma password',
                  style: kButtonStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
