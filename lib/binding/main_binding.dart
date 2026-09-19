import 'package:get/get.dart';

import '../controller/main_controller.dart';
import '../controller/post_controller.dart';
import '../controller/user_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MainController>()) {
      Get.lazyPut<MainController>(() => MainController());
    }

    if (!Get.isRegistered<PostController>()) {
      Get.lazyPut<PostController>(() => PostController());
    }

    if (!Get.isRegistered<UserController>()) {
      Get.lazyPut<UserController>(() => UserController());
    }
  }
}
