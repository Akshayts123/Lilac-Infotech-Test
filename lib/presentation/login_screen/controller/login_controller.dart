import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final phoneNo = TextEditingController();
  static String verify = "";
  static String phonenumber = "";
  String initialCountry = 'IN';
  String? phoneno;
  String? dialno;
  PhoneNumber? patriot;
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  bool isTap = false;
  bool enableBttn = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  Future<void> logout() async {
    await auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenLogin', false);
    Get.toNamed(Routes.LOGIN);
  }
  Future<bool> _onBackPressed() {
    SystemNavigator.pop();
    return Future<bool>.value(true);
  }
}
