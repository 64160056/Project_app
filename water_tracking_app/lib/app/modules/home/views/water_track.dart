import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/controllers/water_controller.dart';
import 'package:water_tracking_app/app/modules/home/views/DrinkWater.dart';
import 'package:water_tracking_app/app/modules/home/views/Noti_view.dart';
import 'dart:math' as math;

import 'package:water_tracking_app/app/modules/home/views/add_weter.dart';

class WaterTrack extends StatefulWidget {
  static const String nameRoute = '/water_track';

  const WaterTrack({super.key});

  @override
  _WaterTrackState createState() => _WaterTrackState();
}

class _WaterTrackState extends State<WaterTrack>
    with SingleTickerProviderStateMixin {
  final RxInt waterAmount = 0.obs;
  final double maxWaterLevel = 2500.0;
  late AnimationController _controller;
  final WaterController waterController = Get.put(WaterController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Repeat the animation to simulate the water flow
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Ensure the controller is disposed to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'เป้าหมายการดื่มน้ำของคุณ',
          style:
              TextStyle(fontSize: 25, color: Color.fromARGB(255, 0, 94, 188)),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${maxWaterLevel.toInt()} ml',
              style: const TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 0, 94, 188),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.blue, width: 5),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100), // ทำให้เป็นวงรี
                      child: ClipPath(
                        clipper: WaterClipper(
                            progress: waterController.waterAmount.value /
                                maxWaterLevel),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: WaterPainter(_controller.value),
                              child: Container(
                                width: 200,
                                height: 400,
                                color: Colors.blueAccent,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 420 -
                          (400 *
                              (waterController.waterAmount.value /
                                  maxWaterLevel)),
                      child: Text(
                        '${(waterController.waterAmount.value / maxWaterLevel * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.to(DrinkWater());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 236, 255, 165),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(150, 60),
                    ),
                    child: const Text(
                      'เป้าหมายใหม่',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      // Update water amount
                      final int? addedAmount = await Get.to(() => AddWeter());
                      if (addedAmount != null) {
                        waterController.addWater(addedAmount);
                      }
                    },
                    backgroundColor: const Color.fromARGB(255, 149, 219, 173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlue[50],
        iconSize: 35,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0){
            Get.to(() => WaterTrack());
          }
          if (index == 2) {
            // สมมติว่าตำแหน่งที่ 2 คือหน้าการแจ้งเตือน
            Get.to(() => NotiView());
          }
        },
        items: const [
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
      ),
    );
  }
}

class WaterPainter extends CustomPainter {
  final double animationValue;
  WaterPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blueAccent;
    final path = Path();

    const double waveHeight = 20;
    const double waveFrequency = 1.5 * math.pi;

    for (double x = 0; x <= size.width; x++) {
      final double y = waveHeight *
          math.sin(
              (x / size.width * waveFrequency) + animationValue * 2 * math.pi);
      if (x == 0) {
        path.moveTo(x, size.height / 2 + y);
      } else {
        path.lineTo(x, size.height / 2 + y);
      }
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WaterClipper extends CustomClipper<Path> {
  final double progress;
  WaterClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * (1 - progress));
    path.lineTo(size.width, size.height * (1 - progress));
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
