import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ฟังก์ชันเพิ่มข้อมูลน้ำลงใน Firestore
Future<void> addWaterData(int amount) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // ข้อมูลที่จะเพิ่มใน Firestore
    final data = {
      'amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': user.uid,  // ใช้ uid ของผู้ใช้ที่ลงชื่อเข้าใช้
    };

    // เพิ่มข้อมูลลงใน Firestore
    await FirebaseFirestore.instance.collection('water_tracking').add(data);
    print("Water data added for user: ${user.uid}");
  } else {
    print("No user is signed in.");
  }
}
