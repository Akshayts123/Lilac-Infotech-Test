import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lilac_infotech/routes/app_pages.dart';
import 'package:lilac_infotech/routes/app_routes.dart';
import 'data/controller/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) => Obx(
        () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Lilac Infotech Test",
          theme: themeController.currentTheme.value,
          defaultTransition: Transition.fadeIn,
          getPages: AppPages.routes,
          initialRoute: Routes.SPLASH,
        ),
      );
}
