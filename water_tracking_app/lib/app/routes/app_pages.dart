import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/views/add_weter.dart';
import 'package:water_tracking_app/app/modules/home/views/info_view.dart';
import 'package:water_tracking_app/app/modules/home/views/profile_view.dart';


import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/water_track.dart';

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
    GetPage(
      name: _Paths.WaterTrack,
      page: () => WaterTrack(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AddWeter,
      page: () => AddWeter(),
      binding: HomeBinding(),
    ),
        GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: HomeBinding(),
    ),
  ];
}
