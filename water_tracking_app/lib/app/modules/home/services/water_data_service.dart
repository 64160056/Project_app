import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ฟังก์ชันเพิ่มข้อมูลน้ำที่ดื่ม
  Future<void> addWaterIntake(int amount) async {
    try {
      await _db.collection('waterIntake').add({
        'amount': amount,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding water intake: $e');
      throw Exception('Failed to add water intake');
    }
  }

  // ฟังก์ชันดึงข้อมูลน้ำที่ดื่ม
  Future<List<Map<String, dynamic>>> getWaterIntake() async {
    try {
      final snapshot = await _db.collection('waterIntake').orderBy('timestamp').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'amount': data['amount'] ?? 0,
          'timestamp': (data['timestamp'] as Timestamp).toDate(),
        };
      }).toList();
    } catch (e) {
      print('Error fetching water intake data: $e');
      throw Exception('Failed to fetch water intake data');
    }
  }
}
Future<void> updateWaterIntake(String userId, int newIntake) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  // ตรวจสอบว่าเอกสารมีอยู่ไหม
  final docSnapshot = await userDoc.get();

  if (docSnapshot.exists) {
    // ถ้าเอกสารมีอยู่ อัปเดตข้อมูล
    await userDoc.update({
      'waterIntake': newIntake,
    }).catchError((error) {
      print('Error updating water intake: $error');
    });
  } else {
    // ถ้าไม่มีเอกสาร สร้างเอกสารใหม่
    await userDoc.set({
      'waterIntake': newIntake,
    },SetOptions(merge: true)
    ).catchError((error) {
      print('Error creating document: $error');
    });
  }
}
