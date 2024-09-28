import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/views/info_view.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.to(() => WaterTrack());
      }),
    );
  }
}
