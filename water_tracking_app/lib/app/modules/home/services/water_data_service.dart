import 'package:cloud_firestore/cloud_firestore.dart';

class WaterDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ฟังก์ชันเพิ่มข้อมูลน้ำที่ดื่ม
  Future<void> addWaterIntake(int amount) async {
    await _db.collection('waterIntake').add({
      'amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ฟังก์ชันดึงข้อมูลน้ำที่ดื่ม
  Future<List<Map<String, dynamic>>> getWaterIntake() async {
    final snapshot = await _db.collection('waterIntake').orderBy('timestamp').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
