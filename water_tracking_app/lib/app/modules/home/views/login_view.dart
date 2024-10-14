import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_tracking_app/app/modules/home/views/add_weight.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';
import 'register_view.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RxBool _isLoading = false.obs; // Loading state

  Future<void> signIn(String email, String password) async {
  _isLoading.value = true; // Start loading

  try {
    // Attempt to sign in the user
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get the user document from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).get();

    // Check if user document exists and navigate accordingly
    if (userDoc.exists) {
      // Navigate to the WaterTrack page if user data exists
      Get.off(() => WaterTrack());
    } else {
      // Navigate to AddWeight page if user data does not exist
      Get.off(() => AddWeight());
    }

    // Show success message
    Get.snackbar('Success', 'Logged in successfully');
  } on FirebaseAuthException catch (e) {
    // Handle specific Firebase authentication errors
    String message = 'Login failed. Please try again.';
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      case 'user-disabled':
        message = 'The user account has been disabled.';
        break;
      default:
        message = e.message ?? message; // Fallback to generic message
        break;
    }
    // Show error message
    Get.snackbar('Error', message);
  } catch (e) {
    // Handle any other errors
    Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}');
  } finally {
    _isLoading.value = false; // Stop loading
  }
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                // Logo at the top
                Image.asset(
                  'assets/water2.png',
                  height: 100,
                ),
                const SizedBox(height: 40),

                // Email input
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.emailAddress,
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

                // Register link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
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
                Obx(() => ElevatedButton(
                  onPressed: _isLoading.value ? null : () {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    if (email.isNotEmpty && password.isNotEmpty) {
                      signIn(email, password);
                    } else {
                      Get.snackbar('Error', 'Please fill in both fields.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: _isLoading.value
                      ? CircularProgressIndicator(color: Colors.white) // Loading indicator
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.black),
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
