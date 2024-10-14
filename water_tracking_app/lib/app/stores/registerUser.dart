import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> registerUser(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    
    // After creating the user, you can store their data in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'waterIntake': 0, // Initialize water intake
      // Add any other user-specific data here
    });

    print("User registered successfully: ${userCredential.user!.uid}");
  } catch (e) {
    print("Failed to register user: $e");
  }
}
