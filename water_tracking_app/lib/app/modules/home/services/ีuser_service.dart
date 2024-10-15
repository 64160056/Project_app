import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save user data (used during registration)
  Future<void> saveUserData(User user, String username, String email) async {
    // Save user data in Firestore
    await _db.collection('users').doc(user.uid).set({
      'email': email,
      'username': username,  // Save the name correctly
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update user data
  Future<void> updateUserData(String uid, {String? username, String? email, String? password}) async {
    // Prepare a map to hold the fields to be updated
    Map<String, dynamic> updates = {};

    // Add fields to updates map if they are provided
    if (username != null) {
      updates['username'] = username;
    }
    if (email != null) {
      updates['email'] = email;
    }

    // Update the user document in Firestore
    if (updates.isNotEmpty) {
      await _db.collection('users').doc(uid).update(updates);
    }

    // Update the user's email if provided
    if (email != null && email.isNotEmpty) {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(email);
      }
    }

    // Update the user's password if provided
    if (password != null && password.isNotEmpty) {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(password);
      }
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot snapshot = await _db.collection('users').doc(uid).get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>?;  // Safely cast to Map<String, dynamic>
    } else {
      return null;  // Handle the case where no user data exists
    }
  }
}
