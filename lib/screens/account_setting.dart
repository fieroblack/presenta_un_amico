import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/add_new_user.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'package:provider/provider.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({
    super.key,
  });

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  List<bool> isSelected = [true, false];
  late Widget frame;

  @override
  void initState() {
    frame = Center(
      child: Text('prova'),
    );
    super.initState();
  }

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
                    if (!Provider.of<LoggedInUser>(context, listen: false)
                        .admin) return;
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
                            child: Center(
                              child: Text('prova'),
                            ),
                          );
                        } else {
                          frame = const AddNewUserFrame();
                        }
                      },
                    );
                  },
                  isSelected: isSelected,
                  children: [
                    const Text('Gestisci'),
                    Provider.of<LoggedInUser>(context).admin
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
