import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase
import 'package:water_tracking_app/app/modules/home/views/login_view.dart';
import 'home_view.dart'; // Import HomeView (or your desired view)

class RegisterView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  RegisterView({super.key});

  // Method for registering user with Firebase
  Future<void> registerUser(String email, String password) async {
    try {
      // Firebase method to create a new user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Registration success - นำทางไปยังหน้า HomeView
      Get.off(() => LoginView()); // นำผู้ใช้ไปยังหน้า HomeView หลังจากสมัครสมาชิกสำเร็จ
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The account already exists for that email.');
      } else {
        Get.snackbar('Error', e.message ?? 'Registration failed.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20), // Add padding for content
        decoration: BoxDecoration(
          color: Colors.blue[50], // Background color for the whole body
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20), // Padding inside the inner container
            decoration: BoxDecoration(
              color: Colors.white, // Inner container background color
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
                  controller: _usernameController, // Bind the controller
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 20),

                // Password input
                TextField(
                  controller: _passwordController, // Bind the controller
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm password input
                TextField(
                  controller: _confirmPasswordController, // Bind the controller
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'ยืนยันรหัสผ่าน',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 40),

                // Register button
                ElevatedButton(
                  onPressed: () {
                    // Get the values of email and password from the input fields
                    String email = _usernameController.text;
                    String password = _passwordController.text;
                    String confirmPassword = _confirmPasswordController.text;

                    if (password == confirmPassword) {
                      registerUser(email, password); // Call register method
                    } else {
                      Get.snackbar('Error', 'Passwords do not match.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: Colors.lightBlue, // Blue background
                  ),
                  child: const Text(
                    'ยืนยัน',
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
