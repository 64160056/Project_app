import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/services/water_data_service.dart'; // นำเข้าบริการน้ำ

class WaterController extends GetxController {
  final WaterDataService waterDataService = WaterDataService();
  final waterAmount = 0.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid; // รับ UID ของผู้ใช้ปัจจุบัน
  final double maxWaterLevel = 2500.0;

  @override
  void onInit() {
    super.onInit();
    fetchWaterData(); // ดึงข้อมูลน้ำที่ดื่มเมื่อเริ่มต้นใช้งาน
  }

  // ฟังก์ชันเพิ่มน้ำที่ดื่ม
  void addWater(int amount) async {
    try {
      waterAmount.value = (waterAmount.value + amount).clamp(0, maxWaterLevel.toInt());
      await _storeWaterIntake(amount); // เก็บข้อมูลน้ำที่ดื่มใน Firestore
      await waterDataService.addWaterIntake(amount); // บันทึกข้อมูลน้ำที่ดื่มผ่าน service
    } catch (e) {
      print("Error adding water intake: $e");
      // คุณสามารถเพิ่มการแสดงแจ้งเตือนหรือข้อความแสดงข้อผิดพลาดได้ที่นี่
    }
  }

  // ฟังก์ชันดึงข้อมูลน้ำที่ดื่มจาก Firestore
  void fetchWaterData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        waterAmount.value = data['totalWater'] ?? 0; // ถ้าหากมีข้อมูลน้ำที่ดื่มจะดึงมาแสดง
      }
    } catch (e) {
      print("Error fetching water data: $e");
      // คุณสามารถเพิ่มการแสดงแจ้งเตือนหรือข้อความแสดงข้อผิดพลาดได้ที่นี่
    }
  }

  // ฟังก์ชันเก็บข้อมูลการดื่มน้ำลงใน Firestore
  Future<void> _storeWaterIntake(int amount) async {
    String? email = FirebaseAuth.instance.currentUser?.email; // ดึง email ของผู้ใช้

    // ต้องแปลง waterAmount.value เป็น int ก่อนบันทึก
    await _firestore.collection('users').doc(userId).set({
      'amount': amount,                      // ปริมาณน้ำที่เพิ่มขึ้น
      'totalWater': waterAmount.value,       // ปริมาณน้ำรวม (ต้องเป็น int)
      'lastIntake': Timestamp.now(),         // เวลาของการดื่มน้ำครั้งล่าสุด
      'email': email,                        // บันทึก email ของผู้ใช้ลงใน Firestore
    }, SetOptions(merge: true))              // merge: true เพื่อไม่ให้ข้อมูลอื่นๆ ถูกเขียนทับ
    .catchError((error) {
      print("Error updating water intake: $error");
    });
  }
}
