import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants.dart';

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
        bool result = await _func();
        if (!result) {
          controller.failure();
          await Future.delayed(const Duration(seconds: 1));
          controller.reset();
        }
      },
    );
  }
}
