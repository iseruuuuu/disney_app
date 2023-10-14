import 'dart:ui';

import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: AppColorStyle.appColor,
                size: 50,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
