import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/Helper/sharedPref.dart';
import '../../../../core/Helper/snackbar_toast_helper.dart';

class EditProfileController extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  var finalDateFormat = ''.obs;
  var formatted = ''.obs;
  var selectedDate = DateTime.now().obs;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      var month = DateFormat.MMMM().format(selectedDate.value);
      finalDateFormat.value = "${selectedDate.value.day}-$month-${selectedDate.value.year}";
      formatted.value = finalDateFormat.value;
    }
  }

  Future<void> saveProfile(Function refresh) async {
    if (nameController.text.toString().length >= 1) {
      await setSharedPrefrence(Name, nameController.text.toString());
    }
    if (emailController.text.toString().length >= 1) {
      await setSharedPrefrence(Email, emailController.text.toString());
    }
    if (formatted.isNotEmpty) {
      await setSharedPrefrence(DOB, formatted.value);
    }
    refresh();
    showToastSuccess("Profile Updated!");
  }
}
