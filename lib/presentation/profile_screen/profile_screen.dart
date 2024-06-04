import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lilac_infotech/presentation/profile_screen/edit_profile/controller/edit_controller.dart';
import '../../core/constants/assets_utils.dart';
import 'controller/profile_controller.dart';

import 'edit_profile/edit_profile.dart';

class ProfilePage extends StatelessWidget {
  final  controller = Get.put(ProfileController());
  final  Editcontroller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
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
          title: Text(
            "My Profile",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(refresh: controller.reee),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Edit",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      return Container(
                        child: controller.imgg.value.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(),
                            child: Image.file(File(controller.imgg.value)),
                          ),
                        )
                            : Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(assetsPath + "prof.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          await controller.pickImage();
                        },
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 18,
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              SizedBox(height: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 18, color: Theme.of(context).primaryColor),
                        SizedBox(width: 10),
                        Obx(() {
                          return Text(
                            controller.namee.value.isNotEmpty
                                ? controller.namee.value
                                : "Name",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          );
                        }),
                      ],
                    ),
                    Divider(thickness: 0.5),
                    Row(
                      children: [
                        Icon(Icons.email_outlined,
                            size: 18, color: Theme.of(context).primaryColor),
                        SizedBox(width: 10),
                        Obx(() {
                          return Text(
                            controller.emaill.value.isNotEmpty
                                ? controller.emaill.value
                                : "Email",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          );
                        }),
                      ],
                    ),
                    Divider(thickness: 0.5),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 10),
                        Obx(() {
                          return Text(
                            controller.dob.value.isNotEmpty
                                ? controller.dob.value
                                : "Date of Birth",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
