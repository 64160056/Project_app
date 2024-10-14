import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/services/water_data_service.dart'; // นำเข้าบริการน้ำ

class WaterController extends GetxController {
  final WaterDataService waterDataService = WaterDataService();
  var waterAmount = 0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId =
      FirebaseAuth.instance.currentUser!.uid; // Get the current user's UID
  final double maxWaterLevel = 2500.0;

  @override
  void onInit() {
    super.onInit();
    fetchWaterData(); // Fetch existing water data when initializing
  }

  // ฟังก์ชันเพิ่มน้ำที่ดื่ม
  void addWater(int amount) async {
    try {
      waterAmount.value =
          (waterAmount.value + amount).clamp(0, maxWaterLevel.toInt());
      await _storeWaterIntake(amount);
      await waterDataService.addWaterIntake(amount); // บันทึกข้อมูลน้ำที่ดื่ม
    } catch (e) {
      print("Error adding water intake: $e");
      // คุณสามารถเพิ่มการแสดงแจ้งเตือนหรือข้อความแสดงข้อผิดพลาดได้ที่นี่
    }
  }

  // ฟังก์ชันดึงข้อมูลน้ำที่ดื่ม
  void fetchWaterData() async {
    try {
      // Fetch water consumption data from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        waterAmount.value =
            data['totalWater'] ?? 0; // Assuming you store totalWater
      }
    } catch (e) {
      print("Error fetching water data: $e");
      // Handle fetch error (show alert or log)
    }
  }

  Future<void> _storeWaterIntake(int amount) async {
    // Update water intake in Firestore
    await _firestore.collection('users').doc(userId).update({
      'amount': amount,
      'totalWater': waterAmount.value, // Update total water intake
      'lastIntake': Timestamp.now(), // Optional: store last intake time
    }).catchError((error) {
      print("Error updating water intake: $error");
      // Handle the error (show alert or log)
    });
  }
}
