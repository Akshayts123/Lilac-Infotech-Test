import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lilac_infotech/data/controller/theme_controller.dart';
import 'package:lilac_infotech/theme/themeData.dart';
import '../../../widget/button/button_custom.dart';
import 'controller/edit_controller.dart';

class EditProfile extends StatelessWidget {
  final Function refresh;
  const EditProfile({Key? key, required this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());
    final ThemeController themeController = Get.put(ThemeController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: GestureDetector(
            child: Icon(Icons.arrow_back_outlined, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text("Edit Profile",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: controller.nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline,
                    color: Theme.of(context).primaryColor),
                labelText: "Username",
                labelStyle: GoogleFonts.poppins(fontSize: 14),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(),
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: controller.emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined,
                    color: Theme.of(context).primaryColor),
                labelText: "Email",
                labelStyle: GoogleFonts.poppins(fontSize: 14),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(),
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                controller.selectDate(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: themeController.currentTheme.value == Darkmode
                          ? Colors.grey
                          : Colors.black45),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Obx(() => Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Theme.of(context).primaryColor),
                    SizedBox(width: 10),
                    controller.formatted.isNotEmpty
                        ? Text(controller.formatted.value,
                        style: TextStyle(fontSize: 15))
                        : Text(
                      "Date Of Birth",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
              ),
            ),
            Spacer(),
            CustomButton(
              color: Theme.of(context).primaryColor,
              height: 50,
              onPressed: () async {
                await controller.saveProfile(refresh);
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
