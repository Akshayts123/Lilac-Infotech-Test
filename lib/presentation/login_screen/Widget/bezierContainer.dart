import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lilac_infotech/presentation/login_screen/Widget/wave.dart';
import 'package:lilac_infotech/theme/themeData.dart';
import '../../../data/controller/theme_controller.dart';

class BezierContainer extends StatelessWidget {
  BezierContainer({Key? key}) : super(key: key);
  final themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        child: Stack(
      children: [
        Container(
          // decoration: BoxDecoration(color:themeController.currentTheme.value.primaryColor,image: DecorationImage(image: AssetImage("assets/images/login_back_1.jpg"),fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken))),
          height: size.height - 00,
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuad,
          // top:  11.h,
          child: WaveWidget(
            size: size,
            yOffset: size.height / 9,
            // yOffset:ResponsiveWidget.isSmallScreen(context)?size.height / 3:ResponsiveWidget.isMediumScreen(context)?size.height / 2.5:size.height / 2.5,
            color: themeController.currentTheme.value == Darkmode
                ? Theme.of(context).scaffoldBackgroundColor
                : Color(0xfff6f6f6),
          ),
        ),
      ],
    ));
  }
}
