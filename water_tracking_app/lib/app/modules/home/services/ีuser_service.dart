import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user data
  Future<void> saveUserData(User user, String name) async {
    await _db.collection('users').doc(user.uid).set({
      'email': user.email,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot snapshot = await _db.collection('users').doc(uid).get();
    return snapshot.data() as Map<String, dynamic>?;
  }
}
