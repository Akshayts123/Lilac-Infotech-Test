import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lilac_infotech/presentation/login_screen/controller/login_controller.dart';

import '../dark/dark_mode.dart';

class DrawerWidget extends StatefulWidget {
  final data;
  const DrawerWidget({Key? key, this.data}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool value = false;
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              _createDrawerHeader(),
              ChangeThemeButtonWidget(),
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                child: ListTile(
                  trailing: Icon(Icons.power_settings_new_rounded,
                      color: Colors.white, size: 20),
                  tileColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onTap: () {
                    _showBottomSheet(context);
                  },
                  // leading: Container( padding: EdgeInsets.only(left: 10),child: Icon(Icons.logout)),
                  title: Text(
                    'Log Out ',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDrawerHeader() {
    return DrawerHeader(
        padding: EdgeInsets.zero,
        child: Stack(children: <Widget>[
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Image.asset(
                'assets/logo-lilac.png',
                width: 130,
                height: 130,
              ),
            ),
          ),
        ]));
  }

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return WillPopScope(
          onWillPop: () async {
            // Handle back button press
            return true; // Prevent closing the bottom sheet
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            height: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Do you want to log out ?",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  child: Text(
                    "This operation cant be undone if you have choosed ! select your best choice",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        print('no selected');
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "No",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2))),
                    )),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.logout();
                        },
                        child: Text(
                          "Yes",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            surfaceTintColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            backgroundColor: Theme.of(context).primaryColor
                            // primary: Theme.of(context).primaryColor
                            ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
