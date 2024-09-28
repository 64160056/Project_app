import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/views/info_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
       GetPage(
      name: _Paths.INFO,
      page: () => const InfoView(),
      binding: HomeBinding(),
    ),
  ];
}
