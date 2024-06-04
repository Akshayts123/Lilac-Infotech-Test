import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home_screen/home_screen.dart';

class OTPController extends GetxController {
  var otpController = TextEditingController().obs;
  var verificationId = ''.obs;
  var phoneno = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('phoneno')) {
      phoneno.value = arguments["phoneno"];
      _verifyPhone();
    } else {
      // Handle the case where phoneno is not provided
      print("Phone number not provided");
    }
  }

  Future<void> _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneno.value,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            Get.offAll(() => MyHomePage());
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        this.verificationId.value = verificationID;
      },
      timeout: Duration(seconds: 120),
    );
  }

  Future<void> verifyOTP(String otp) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId.value,
          smsCode: otp,
        ),
      ).then((value) async {
        if (value.user != null) {
          Get.offAll(() => MyHomePage());
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void resendOTP() {
    _verifyPhone();
  }
}
