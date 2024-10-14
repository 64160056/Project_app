import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:water_tracking_app/app/modules/home/views/login_view.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final RxBool _isLoading = false.obs;

  RegisterView({super.key});

  // Method for registering user with Firebase and storing user data in Firestore
  Future<void> registerUser(String email, String password) async {
    try {
      _isLoading.value = true; // Start loading

      // Firebase method to create a new user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful registration, create a document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'weight': null, // Initialize weight to null
        'waterIntake': 0, // Initialize water intake to 0
      });

      // Registration success - navigate to LoginView
      Get.off(() => LoginView());
      Get.snackbar('Success', 'Registration successful!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The account already exists for that email.');
      } else {
        Get.snackbar('Error', e.message ?? 'Registration failed.');
      }
    } finally {
      _isLoading.value = false; // Stop loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue[50],
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/water2.png', // Replace with your image path
                  height: 100,
                ),
                const SizedBox(height: 40),

                // Username input (Email)
                TextField(
                  controller: _usernameController,
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
                const SizedBox(height: 20),

                // Confirm password input
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 40),

                // Register button
                Obx(() => ElevatedButton(
                      onPressed: _isLoading.value
                          ? null
                          : () {
                              String email = _usernameController.text;
                              String password = _passwordController.text;
                              String confirmPassword =
                                  _confirmPasswordController.text;

                              if (password == confirmPassword) {
                                registerUser(
                                    email, password); // Call register method
                              } else {
                                Get.snackbar(
                                    'Error', 'Passwords do not match.');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: _isLoading.value
                          ? CircularProgressIndicator()
                          : const Text(
                              'Confirm',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
