import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:lilac_infotech/presentation/profile_screen/edit_profile/edit_profile.dart';
import '../presentation/home_screen/binding/home_binding.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/login_screen/binding/authendication_binding.dart';
import '../presentation/login_screen/login.dart';
import '../presentation/otp_screen/otp_screen.dart';
import '../presentation/profile_screen/binding/profile_binding.dart';
import '../presentation/profile_screen/edit_profile/binding/edit_profile_binding.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/splash_screen/binding/splash_binding.dart';
import '../presentation/splash_screen/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Paths.SPLASH,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Paths.HOME,
      page: () => MyHomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Paths.LOGIN,
      page: () => LoginScreen(),
      binding: AuthendicationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Paths.OTP,
      page: () => OTPScreen(),
      binding: AuthendicationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Paths.PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),

  ];
}
