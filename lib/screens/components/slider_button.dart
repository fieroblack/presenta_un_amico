import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants.dart';

class SliderSubmit extends StatelessWidget {
  const SliderSubmit({
    super.key,
    required String label,
  }) : _label = label;

  final String _label;

  @override
  Widget build(BuildContext context) {
    return ActionSlider.standard(
      boxShadow: const [],
      backgroundColor: Colors.grey[300],
      rolling: true,
      toggleColor: LogoColor.greenLogoColor,
      child: Text(_label),
      action: (controller) async {
        controller.loading();
        await Future.delayed(const Duration(seconds: 1));
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.reset();
      },
    );
  }
}
