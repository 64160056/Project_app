import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class InfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
