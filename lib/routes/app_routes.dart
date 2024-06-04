abstract class Routes {
  Routes._();

  static const HOME = Paths.HOME;
  static const SPLASH = Paths.SPLASH;
  static const LOGIN = Paths.LOGIN;
  static const OTP = Paths.OTP;
  static const PROFILE = Paths.PROFILE;
}

abstract class Paths {
  static const HOME = '/home_screen';
  static const SPLASH = '/splash_screen';
  static const LOGIN = '/login';
  static const OTP = '/otp_screen';
  static const PROFILE = '/profile_screen';
}
