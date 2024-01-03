import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants.dart';

class SliderSubmit extends StatelessWidget {
  const SliderSubmit(
      {super.key, required String label, required Function() func})
      : _func = func,
        _label = label;

  final String _label;
  final Function() _func;

  @override
  Widget build(BuildContext context) {
    return ActionSlider.standard(
      boxShadow: const [],
      backgroundColor: Colors.grey[300],
      rolling: true,
      toggleColor: LogoColor.greenLogoColor,
      child: Text(_label),
      action: (controller) async {
        //TODO gestione dell'errore dispose
        controller.loading();
        _func();
        controller.success();
        await Future.delayed(const Duration(milliseconds: 500));

        await Future.delayed(const Duration(seconds: 1));
        controller.reset();
      },
    );
  }
}
