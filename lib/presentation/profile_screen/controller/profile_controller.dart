import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/Helper/sharedPref.dart';
import '../../../core/Helper/snackbar_toast_helper.dart';


class ProfileController extends GetxController {
  var namee = ''.obs;
  var emaill = ''.obs;
  var dob = ''.obs;
  var imgg = ''.obs;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadImage();
    reee();
  }

  Future<void> reee() async {
    var getPath = await getSharedPrefrence(IMG);
    var nm = await getSharedPrefrence(Name);
    var em = await getSharedPrefrence(Email);
    var dt = await getSharedPrefrence(DOB);
    imgg.value = getPath ?? '';
    namee.value = nm ?? '';
    emaill.value = em ?? '';
    dob.value = dt ?? '';
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', pickedFile.path);
      imgg.value = pickedFile.path;
    }
  }

  Future<void> loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      _image = File(imagePath);
    }
  }

  Future<void> uploadImage() async {
    try {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (pickedImage == null) return;
      final imageTemp = File(pickedImage.path);
      _image = imageTemp;
      imgg.value = pickedImage.path;
      await setSharedPrefrence(IMG, pickedImage.path);
      showToastSuccess("Photo Updated!");
    } on PlatformException catch (e) {
      showToastError("Failed to pick image: $e");
    }
  }
}
