import 'package:get/get.dart';
import 'package:water_tracking_app/LoginPage.dart';
import 'package:water_tracking_app/app/modules/home/views/DrinkWater.dart';
import 'package:water_tracking_app/app/modules/home/views/Noti_view.dart';
import 'package:water_tracking_app/app/modules/home/views/add_weter.dart';
import 'package:water_tracking_app/app/modules/home/views/info_view.dart';
import 'package:water_tracking_app/app/modules/home/views/login_view.dart';
import 'package:water_tracking_app/app/modules/home/views/profile_view.dart';
import 'package:water_tracking_app/app/modules/home/views/register_view.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';
import 'package:water_tracking_app/register.dart';


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
    GetPage(
      name: _Paths.WATERTRACK,
      page: () => WaterTrack(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADDWATER,
      page: () => AddWeter(),
      binding: HomeBinding(),
    ),
        GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotiView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DRINKWATER,
      page: () => DrinkWater(),
      binding: HomeBinding(),
    ),
  ];
}
