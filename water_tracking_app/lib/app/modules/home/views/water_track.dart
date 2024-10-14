import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/controllers/water_controller.dart';

import 'dart:math' as math;

import 'package:water_tracking_app/app/modules/home/views/add_weter.dart';
import 'package:water_tracking_app/app/modules/home/views/component/Tapbar.dart';


class WaterTrack extends StatefulWidget {
  static const String nameRoute = '/water_track';

  @override
  _WaterTrackState createState() => _WaterTrackState();
}

class _WaterTrackState extends State<WaterTrack>
    with SingleTickerProviderStateMixin {
  final double maxWaterLevel = 2500.0; // กำหนดระดับน้ำสูงสุด
  late AnimationController _controller;
  final WaterController waterController = Get.put(WaterController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // ทำให้การเคลื่อนไหวเกิดขึ้นซ้ำ
  }

  @override
  void dispose() {
    _controller.dispose(); // ปล่อย controller เพื่อลดการใช้หน่วยความจำ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'เป้าหมายการดื่มน้ำของคุณ',
          style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 0, 94, 188)),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${maxWaterLevel.toInt()} ml',
              style: TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 0, 94, 188),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
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
                          progress: waterController.waterAmount.value / maxWaterLevel,
                        ),
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
                      top: 420 - (400 * (waterController.waterAmount.value / maxWaterLevel)),
                      child: Text(
                        '${(waterController.waterAmount.value / maxWaterLevel * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle เป้าหมายใหม่ (ตั้งค่าหรือรีเซ็ตเป้าหมาย)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 236, 255, 165),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(150, 60),
                    ),
                    child: Text(
                      'เป้าหมายใหม่',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      // เปิดหน้าต่างเพิ่มน้ำ
                      final int? addedAmount = await Get.to(() => AddWeter());
                      if (addedAmount != null) {
                        waterController.addWater(addedAmount); // เพิ่มน้ำที่ดื่ม
                      }
                    },
                    backgroundColor: const Color.fromARGB(255, 149, 219, 173),
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Tapbar(), // ใช้ CustomNavigationBar ที่แยกไว้
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

    final double waveHeight = 20;
    final double waveFrequency = 1.5 * math.pi;

    for (double x = 0; x <= size.width; x++) {
      final double y = waveHeight *
          math.sin((x / size.width * waveFrequency) + animationValue * 2 * math.pi);
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
