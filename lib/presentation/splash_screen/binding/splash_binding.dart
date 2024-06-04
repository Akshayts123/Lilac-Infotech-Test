import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controller/splash_controller.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(SplashScreenViewModel());
  }
}
