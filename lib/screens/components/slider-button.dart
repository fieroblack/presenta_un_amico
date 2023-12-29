import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import '../../utilities/constants.dart';

class SliderSubmit extends StatelessWidget {
  const SliderSubmit({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return ActionSlider.standard(
      boxShadow: [],
      backgroundColor: Colors.grey[300],
      rolling: true,
      toggleColor: LogoColor.greenLogoColor,
      child: Text(label),
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
