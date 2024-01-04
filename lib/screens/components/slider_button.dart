import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import '../../utilities/constants.dart';
import '../main_page.dart';

class SliderSubmit extends StatelessWidget {
  SliderSubmit({super.key, required String label, required Function() func})
      : _func = func,
        _label = label;

  final String _label;
  final Function() _func;

  final Color toggleColor = LogoColor.greenLogoColor;

  @override
  Widget build(BuildContext context) {
    return ActionSlider.standard(
      boxShadow: const [],
      backgroundColor: Colors.grey[300],
      rolling: true,
      toggleColor: toggleColor,
      successIcon: const Icon(Icons.check),
      failureIcon: const Icon(
        Icons.close,
      ),
      child: Text(_label),
      action: (controller) async {
        controller.loading();
        await Future.delayed(const Duration(milliseconds: 500));
        LoggedInUser user = await _func();
        if (user.loggedIn) {
          controller.success();
          await Future.delayed(const Duration(seconds: 1));
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
        } else {
          controller.failure();
          await Future.delayed(const Duration(seconds: 1));
          controller.reset();
        }
      },
    );
  }
}
