import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controller/home_controller.dart';
import '../controller/list_controller.dart';


class HomeBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(VideoPlayerControllers());
    Get.put(VideoListController());
  }
}