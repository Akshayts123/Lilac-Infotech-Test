import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../../routes/app_routes.dart';

class SplashScreenViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startDelay();
  }

  void _startDelay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenLogin = prefs.getBool('hasSeenLogin') ?? false;

    Timer(Duration(seconds: 5), () => _navigateToNextScreen(hasSeenLogin));
  }

  void _navigateToNextScreen(bool hasSeenLogin) {
    if (hasSeenLogin) {
      Get.toNamed(
          Routes.HOME); // Adjust the route name according to your project setup
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }
}
