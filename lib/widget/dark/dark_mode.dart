import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lilac_infotech/data/controller/theme_controller.dart';
import '../../theme/themeData.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  @override
  _ChangeThemeButtonWidgetState createState() =>
      _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  late ThemeController themeController;

  @override
  void initState() {
    super.initState();
    themeController = Get.put(ThemeController());
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
        child: themeController.currentTheme.value == Darkmode
            ? Icon(Icons.dark_mode)
            : Icon(Icons.light_mode),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            return Text(
              themeController.currentTheme.value == Darkmode
                  ? "Dark Mode"
                  : "Light Mode",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            );
          }),
        ],
      ),
      trailing: Obx(() {
        return Switch(
          inactiveTrackColor: Color(0xfff6f6f6),
          activeColor: themeController.currentTheme.value.primaryColor,
          value: themeController.currentTheme.value == Darkmode,
          onChanged: (value) {
            setState(() {
              themeController.toggleTheme();
            });
          },
        );
      }),
    );
  }
}
