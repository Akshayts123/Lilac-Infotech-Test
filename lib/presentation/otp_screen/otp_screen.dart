import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_button/timer_button.dart';
import '../../core/Helper/Constants.dart';
import '../login_screen/Widget/bezierContainer.dart';
import 'controller/otp_controller.dart';


class OTPScreen extends StatelessWidget {
  OTPScreen({Key? key}) : super(key: key);

  final  otpController = Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Positioned(child: BezierContainer()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h(MediaQuery.of(context).size.height * 0.2),
                Center(
                  child: Obx(
                        () => Text(
                      "Enter OTP sent to ${otpController.phoneno}",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ),
                h(MediaQuery.of(context).size.height * 0.1),
                otp(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    height: 30,
                    child: TimerButton(
                      label: "Resend OTP",
                      color: Theme.of(context).primaryColor,
                      resetTimerOnPressed: true,
                      buttonType: ButtonType.textButton,
                      timeOutInSeconds: 120,
                      onPressed: () {
                        otpController.resendOTP();
                      },
                      disabledColor: Colors.white,
                      disabledTextStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                      activeTextStyle: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget otp() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      child: Obx(
            () => PinCodeTextField(
          appContext: Get.context!,
          autovalidateMode: AutovalidateMode.always,
          backgroundColor: Colors.transparent,
          controller: otpController.otpController.value,
          length: 6,
          enablePinAutofill: true,
          blinkWhenObscuring: true,
          animationType: AnimationType.fade,
          textStyle: GoogleFonts.poppins(color: Color(0xff666666), fontSize: 18),
          pinTheme: PinTheme(
            inactiveFillColor: Colors.white,
            activeFillColor: Colors.white,
            selectedFillColor: Colors.white,
            selectedColor: Theme.of(Get.context!).primaryColor,
            inactiveColor: Colors.grey.shade300,
            activeColor: Theme.of(Get.context!).primaryColor,
            borderWidth: 0.5,
            selectedBorderWidth: 0.7,
            inactiveBorderWidth: 0.7,
            activeBorderWidth: 0.7,
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 37,
          ),
          cursorColor: Colors.black54,
          cursorHeight: 20,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          autoFocus: true,
          autoDisposeControllers: false,
          keyboardType: TextInputType.number,
          onCompleted: (value) async {
            otpController.verifyOTP(value);
          },
          onChanged: (value) {},
          beforeTextPaste: (text) {
            return true;
          },
        ),
      ),
    );
  }
}
