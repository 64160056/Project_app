import 'package:get/get.dart';
import 'package:water_tracking_app/app/service/water_data_service.dart';// นำเข้าบริการน้ำ

class WaterController extends GetxController {
  final WaterDataService waterDataService = WaterDataService();
  var waterAmount = 0.obs;

  // ฟังก์ชันเพิ่มน้ำที่ดื่ม
  void addWater(int amount) async {
    waterAmount.value += amount;
    await waterDataService.addWaterIntake(amount); // บันทึกข้อมูลน้ำที่ดื่ม
  }

  // ฟังก์ชันดึงข้อมูลน้ำที่ดื่ม
  Future<void> fetchWaterIntake() async {
    List<Map<String, dynamic>> intakeList = await waterDataService.getWaterIntake();
    // ประมวลผลข้อมูลที่ได้รับ
  }
}
