import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controller/login_controller.dart';

class AuthendicationBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(LoginController());
  }
}
