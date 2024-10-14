import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/views/history_view.dart';
import 'package:water_tracking_app/app/modules/home/views/noti_view.dart';
import 'package:water_tracking_app/app/modules/home/views/info_view.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';

class AppRoutes {
  static const waterTrack = '/water_track';
  static const history = '/history';
  static const NOTIFICATION = '/notification';
  static const info = '/info';
}

final List<GetPage> pages = [
  GetPage(name: AppRoutes.waterTrack, page: () => WaterTrack()),
  GetPage(name: AppRoutes.history, page: () => HistoryView()),
  GetPage(name: AppRoutes.NOTIFICATION, page: () => NotiView()),
  GetPage(name: AppRoutes.info, page: () => InfoView()),
];

class Tapbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.lightBlue[50],
      iconSize: 35,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAllNamed(AppRoutes.waterTrack);
            break;
          case 1:
            Get.offAllNamed(AppRoutes.history);
            break;
          case 2:
            Get.offAllNamed(AppRoutes.NOTIFICATION);
            break;
          case 3:
            Get.offAllNamed(AppRoutes.info);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.water_drop),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
    );
  }
}
