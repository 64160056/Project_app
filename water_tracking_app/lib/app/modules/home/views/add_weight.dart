import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:water_tracking_app/app/modules/home/views/DrinkWater.dart';
import 'package:water_tracking_app/app/modules/home/views/profile_view.dart';

class AddWeight extends StatelessWidget {
  const AddWeight({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: WaterTrackerScreen(),
      ),
    );
  }
}

class WaterTrackerScreen extends StatefulWidget {
  @override
  _WaterTrackerScreenState createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  final TextEditingController _weightController = TextEditingController();
  double waterGoal = 0; // Default value

  void _calculateWaterGoal(String value) {
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    // Example calculation: 30 ml per kg of body weight
    setState(() {
      waterGoal = weight * 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'เพิ่มข้อมูลน้ำหนักของคุณ',
            style: TextStyle(
              fontSize: 25,
              color: Colors.blue, // ตั้งค่าสีฟ้าสำหรับข้อความ
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
             TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _calculateWaterGoal(value); // เรียกคำนวณเมื่อมีการเปลี่ยนแปลงใน TextField
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'น้ำหนักของคุณ (kg)',
            ),
          ),
          SizedBox(height: 110),
          Text(
            'เป้าหมายการดื่มของคุณ',
            style: TextStyle(
              fontSize: 25, // กำหนดขนาดตัวอักษร
              color: Colors.blue,
              fontWeight: FontWeight.bold, // กำหนดสีตัวอักษร
            ),
          ),
          SizedBox(height: 10),
          Text(
            '${waterGoal.toStringAsFixed(0)} ml',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 80),
          ElevatedButton(
            onPressed: () {
                Get.to(DrinkWater());
              },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 50),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Let go',
              style: TextStyle(
                fontSize: 20, //
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
