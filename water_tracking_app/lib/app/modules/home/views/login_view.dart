import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:water_tracking_app/app/modules/home/views/add_weight.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';
import 'register_view.dart'; // Import RegisterView here

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ตรวจสอบว่าผู้ใช้มีข้อมูลใน Firestore หรือไม่
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).get();

      if (userDoc.exists) {
        // ถ้ามีข้อมูลให้ไปที่หน้า AddWeight
        Get.off(() => WaterTrack());
      } else {
        // ถ้าไม่มีข้อมูลให้ไปที่หน้า NewUserPage (สร้างหน้าสำหรับผู้ใช้ใหม่)
        Get.off(() => AddWeight()); // สร้างหน้าใหม่ที่คุณต้องการ
      }

      Get.snackbar('Success', 'Logged in successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided.');
      } else {
        Get.snackbar('Error', e.message ?? 'Login failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20), // Add padding inside the container
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.circular(10), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo at the top
                Image.asset(
                  'assets/water2.png', // Replace with the actual image path
                  height: 100,
                ),
                const SizedBox(height: 40), // Add space below the logo

                // Username input (Email)
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 20),

                // Password input
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 10),

                // "สมัครสมาชิก" link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to RegisterView using Get
                      Get.to(() => RegisterView());
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Login button
                ElevatedButton(
                  onPressed: () {
                    // Handle login action
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    signIn(email, password);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.lightBlue, // Blue background
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
