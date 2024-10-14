import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/views/Noti_view.dart';
import 'package:water_tracking_app/app/modules/home/views/add_weight.dart';
import 'package:water_tracking_app/app/modules/home/views/add_weter.dart';
import 'package:water_tracking_app/app/modules/home/views/component/Tapbar.dart';
import 'package:water_tracking_app/app/modules/home/views/profile_view.dart';

import '../controllers/home_controller.dart';

class InfoView extends GetView<HomeController> {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your information', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.lightBlue[100],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(ProfileView());
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: Text('Profile'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.to(AddWeight());
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: Text('Edit your weight'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.logout();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Tapbar(),
    );
  }
}
