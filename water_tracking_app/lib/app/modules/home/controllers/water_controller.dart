import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/services/water_data_service.dart'; // นำเข้าบริการน้ำ

class WaterController extends GetxController {
  final WaterDataService waterDataService = WaterDataService();
  var waterAmount = 0.obs;

  // ฟังก์ชันเพิ่มน้ำที่ดื่ม
  void addWater(int amount) async {
    try {
      waterAmount.value += amount;
      await waterDataService.addWaterIntake(amount); // บันทึกข้อมูลน้ำที่ดื่ม
    } catch (e) {
      print("Error adding water intake: $e");
      // คุณสามารถเพิ่มการแสดงแจ้งเตือนหรือข้อความแสดงข้อผิดพลาดได้ที่นี่
    }
  }

  // ฟังก์ชันดึงข้อมูลน้ำที่ดื่ม
  Future<void> fetchWaterIntake() async {
    try {
      List<Map<String, dynamic>> intakeList = await waterDataService.getWaterIntake();
      // สมมุติว่าคุณต้องการอัปเดต waterAmount ด้วยปริมาณน้ำทั้งหมดที่ดื่ม
      waterAmount.value = intakeList.fold<int>(
        0,
        (previousValue, element) => previousValue + (element['amount'] as int? ?? 0),
      );
    } catch (e) {
      print("Error fetching water intake: $e");
      // คุณสามารถเพิ่มการแสดงแจ้งเตือนหรือข้อความแสดงข้อผิดพลาดได้ที่นี่
    }
  }

  // ฟังก์ชันเริ่มต้นเพื่อดึงข้อมูลเมื่อ Controller ถูกสร้าง
  @override
  void onInit() {
    super.onInit();
    fetchWaterIntake(); // ดึงข้อมูลน้ำที่ดื่มเมื่อ Controller ถูกสร้าง
  }
}
