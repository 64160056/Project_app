import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/views/login_view.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  void increment() => count.value++;
   void logout() {
  
    Get.offAll(LoginView());
  }
}
