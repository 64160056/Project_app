import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/views/DrinkWater.dart';
import 'package:water_tracking_app/app/modules/home/views/login_view.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add the text "มากินน้ำกันเถอะ"
            const Text(
              'มากินน้ำกันเถอะ',
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Add spacing between elements
            // Add the bottle image
            Image.asset(
              'assets/water1.png', // Make sure to add the image to your assets folder
              height: 150,
            ),
            const SizedBox(height: 20),
            // Add the button with text "เริ่ม"
            ElevatedButton(
              onPressed: () {
                Get.to(() => DrinkWater());//<--------------แก้หน้าเชื่อมตรงนี้
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'เริ่ม',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
