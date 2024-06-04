import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:lilac_infotech/presentation/otp_screen/controller/otp_controller.dart';

class OTPBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(OTPController());
  }
}
