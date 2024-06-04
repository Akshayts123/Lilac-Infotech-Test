import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';
import '../../widget/button/button_custom.dart';
import 'Widget/bezierContainer.dart';
import 'controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());
  final TextEditingController numberController = new TextEditingController();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(child: BezierContainer()),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Text(
                    "Register your mobile number",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      "We will send a one-time password to this mobile number",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Form(
                      key: loginController.formKey,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 10,
                                top: 3,
                                bottom: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InternationalPhoneNumberInput(
                                spaceBetweenSelectorAndTextField: 0,
                                onInputChanged: (PhoneNumber number) {
                                  loginController.phoneno = number.phoneNumber;
                                  loginController.dialno = number.dialCode;
                                  setState(() {
                                    loginController.enableBttn =
                                        number.phoneNumber!.length == 13;
                                  });
                                },
                                textStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                inputDecoration: InputDecoration.collapsed(
                                  hintText: "Enter Your Phone No",
                                  hintStyle: TextStyle(
                                    fontFamily: "NunitoSans_10pt",
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                ignoreBlank: false,
                                textFieldController: loginController.phoneNo,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle: TextStyle(
                                  fontFamily: "NunitoSans_10pt",
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                initialValue: loginController.number,
                                formatInput: true,
                                cursorColor: Theme.of(context).primaryColor,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                onSaved: (PhoneNumber number) {
                                  loginController.phoneno = number.phoneNumber;
                                  loginController.dialno = number.dialCode;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            CustomButton(
                              color: loginController.enableBttn
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              height: 50,
                              onPressed: loginController.enableBttn
                                  ? () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool('hasSeenLogin', true);

                                      Get.toNamed(Routes.OTP, arguments: {
                                        "phoneno":
                                            loginController.phoneno.toString(),
                                      });
                                      loginController.phoneNo.clear();
                                    }
                                  : null,
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');
    setState(() {
      this.loginController.number = number;
    });
  }
}
