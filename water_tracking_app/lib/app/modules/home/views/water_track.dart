import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/controllers/water_controller.dart';
import 'package:water_tracking_app/app/modules/home/views/DrinkWater.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ใช้สำหรับบันทึกข้อมูลในเครื่อง
import 'dart:math' as math;

import 'package:water_tracking_app/app/modules/home/views/add_weter.dart';
import 'package:water_tracking_app/app/modules/home/views/component/Tapbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class WaterTrack extends StatefulWidget {
  static const String nameRoute = '/water_track';

  @override
  _WaterTrackState createState() => _WaterTrackState();
}

class _WaterTrackState extends State<WaterTrack>
    with SingleTickerProviderStateMixin {
  final RxInt waterAmount = 0.obs;
  double waterGoal = 2500.0; // Initialize with a default goal
  late AnimationController _controller;
  late ConfettiController _confettiController; // คอนโทรลเลอร์สำหรับเฉลิมฉลอง
  final WaterController waterController = Get.put(WaterController());
  DateTime lastUpdatedDate = DateTime.now(); // เก็บวันที่ล่าสุด

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    _confettiController = ConfettiController(
        duration: const Duration(seconds: 2)); // คอนโทรลเลอร์แอนิเมชัน
    _fetchWaterGoal();
    _checkAndResetForNewDay(); // เช็คว่าเป็นวันใหม่หรือยังเมื่อเปิดแอป
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Ensure the controller is disposed to prevent memory leaks
    super.dispose();
  }

  // ฟังก์ชันเช็ควันใหม่และรีเซต
  Future<void> _checkAndResetForNewDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastDateString = prefs.getString('lastUpdatedDate');

    if (lastDateString != null) {
      lastUpdatedDate = DateTime.parse(lastDateString);
    }

    DateTime currentDate = DateTime.now();

    // ถ้าวันปัจจุบันไม่ตรงกับวันที่ล่าสุด ให้รีเซตน้ำ
    if (currentDate.day != lastUpdatedDate.day ||
        currentDate.month != lastUpdatedDate.month ||
        currentDate.year != lastUpdatedDate.year) {
      setState(() {
        waterController.waterAmount.value = 0; // รีเซตปริมาณน้ำ
      });
      // บันทึกวันที่ใหม่
      prefs.setString('lastUpdatedDate', currentDate.toIso8601String());
    }
  }

  // ฟังก์ชันเฉลิมฉลองและรีเซต
  void _celebrateAndReset() {
    _confettiController.play(); // เริ่มแอนิเมชันเฉลิมฉลอง
  }

  // Fetch water goal from Firestore
  Future<void> _fetchWaterGoal() async {
    final user = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid);
    final doc = await user.get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        waterGoal = doc.data()!['waterGoal'] ??
            5000.0; // Use the fetched goal or default
      });
    }
  }

  // Update water intake in Firestore
  void updateWaterIntake(int addedAmount) {
    final userId =
        FirebaseAuth.instance.currentUser?.uid; // Get the logged-in user's ID
    if (userId != null) {
      if (waterController.waterAmount.value + addedAmount > waterGoal) {
        addedAmount = (waterGoal - waterController.waterAmount.value).toInt();
      }
      FirebaseFirestore.instance.collection('users').doc(userId).set({
        'amount': waterAmount, // Store current amount
        'totalWater': waterAmount.value, // Update total water intake
        'lastIntake': Timestamp.now(),
        'waterIntake':
            FieldValue.increment(addedAmount), // Increment by the added amount
      }, SetOptions(merge: true)).then((_) {
        print("Water intake added/updated successfully!");
      }).catchError((error) {
        print("Error updating water intake: $error");
      });
    } else {
      print("No user is logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'เป้าหมายการดื่มน้ำของคุณ',
            style:
                TextStyle(fontSize: 25, color: Color.fromARGB(255, 0, 94, 188)),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${waterGoal.toInt()} ml', // Display the dynamic water goal
              style: TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 0, 94, 188),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              // เงื่อนไขตรวจสอบถ้าถึง 100% จะเริ่มเฉลิมฉลอง
              if (waterController.waterAmount.value >= waterGoal) {
                _celebrateAndReset();
              }
              return Stack(
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
                    borderRadius: BorderRadius.circular(100),
                    child: ClipPath(
                      clipper: WaterClipper(
                          progress:
                              waterController.waterAmount.value / waterGoal),
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
                  Align(
                    alignment: Alignment.center, // จัดให้ตำแหน่งตรงกลาง
                    child: Text(
                      '${(waterController.waterAmount.value / waterGoal * 100).toInt()}%', // แสดงเปอร์เซ็นต์การดื่มน้ำ
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 197, 197, 197),
                      ),
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 30),
            // Confetti Widget สำหรับแสดงแอนิเมชันเฉลิมฉลอง
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false, // ไม่ทำงานซ้ำ
              colors: const [
                Colors.blue,
                Colors.green,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // กำหนดสีของแอนิเมชัน
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.off(DrinkWater());
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
                      // Update water amount
                      final int? addedAmount = await Get.to(() => AddWeter());
                      if (addedAmount != null) {
                        waterController.addWater(addedAmount);
                        updateWaterIntake(addedAmount); // Call Firestore update
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
      bottomNavigationBar: Tapbar(), // Use CustomNavigationBar as needed
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
