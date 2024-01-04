import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/add_new_user.dart';
import 'package:presenta_un_amico/services/user_model.dart';

class AccountSetting extends StatefulWidget {
  AccountSetting({super.key, required LoggedInUser user}) : _user = user;

  final LoggedInUser _user;

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  Future<void> resetPassword(BuildContext context) async {
    //TODO implementare metodo per reset password
  }

  List<bool> isSelected = [true, false];
  Widget frame = Center(child: Text('Gestisci account'));

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ToggleButtons(
                  constraints: const BoxConstraints(
                    minHeight: 32.0,
                    minWidth: 80.0,
                  ),
                  onPressed: (index) {
                    if (!widget._user.admin) return;
                    setState(
                      () {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelected.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            isSelected[buttonIndex] = true;
                          } else {
                            isSelected[buttonIndex] = false;
                          }
                        }
                        if (index == 0) {
                          frame = Center(
                            child: Text('Gestisci account'),
                          );
                        } else {
                          frame = AddNewUserFrame();
                        }
                      },
                    );
                  },
                  isSelected: isSelected,
                  children: [
                    const Text('Gestisci'),
                    widget._user.admin
                        ? const Text('Crea')
                        : const Icon(
                            Icons.lock,
                            size: 15.0,
                          ),
                  ],
                ),
              ),
              frame,
            ],
          ),
        ),
      ),
    );
  }
}
