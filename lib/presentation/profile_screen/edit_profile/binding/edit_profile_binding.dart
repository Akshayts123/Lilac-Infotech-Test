import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:lilac_infotech/presentation/profile_screen/edit_profile/controller/edit_controller.dart';

class EditProfileBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(EditProfileController());
  }
}
