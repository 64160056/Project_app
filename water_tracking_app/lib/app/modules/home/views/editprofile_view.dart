import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_tracking_app/app/modules/home/views/profile_view.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = true;

  User? _user;
  String _profilePictureUrl = 'assets/profile.png'; // Default profile image

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        // Fetch additional user data from Firestore
        DocumentSnapshot userData =
            await _firestore.collection('users').doc(_user!.uid).get();

        setState(() {
          if (userData.exists) {
            var data = userData.data() as Map<String, dynamic>?;
            _nameController.text = data?['username'] ?? 'No Name';
            _profilePictureUrl = data?['profilePictureUrl'] ?? 'assets/profile.png';
          } else {
            _nameController.text = 'No Name';
          }
          _emailController.text = _user!.email ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _saveProfile() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      if (_user != null) {
        // Update the user's name in Firestore
        await _firestore.collection('users').doc(_user!.uid).update({
          'username': name,
        });

        // Check if email has changed
        if (email.isNotEmpty && email != _user!.email) {
          await _user!.verifyBeforeUpdateEmail(email);
          Get.snackbar('Email Update', 'Check your inbox to verify your new email.');
          return false; // Email update initiated, don't navigate yet
        }

        // Update password if provided
        if (password.isNotEmpty) {
          await _reauthenticateAndChangePassword(password);
        }

        Get.snackbar('Success', 'Profile updated successfully!');
        return true;
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar('Error', 'Failed to update profile: ${e.toString()}');
    }
    return false;
  }

  Future<void> _reauthenticateAndChangePassword(String newPassword) async {
    // Reauthenticate the user with their current credentials
    AuthCredential credential = EmailAuthProvider.credential(
      email: _user!.email!,
      password: _passwordController.text, // Prompt or store the old password for reauth
    );
    
    try {
      UserCredential userCredential = await _user!.reauthenticateWithCredential(credential);

      // Now update the password
      await userCredential.user!.updatePassword(newPassword);
      Get.snackbar('Success', 'Password updated successfully.');
    } catch (e) {
      print('Error updating password: $e');
      Get.snackbar('Error', 'Failed to update password: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profilePictureUrl.contains('http')
                          ? NetworkImage(_profilePictureUrl)
                          : AssetImage(_profilePictureUrl) as ImageProvider,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Add functionality to change profile picture
                        },
                        child: const Text(
                          'Change Profile Picture',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Full Name
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Save Changes button
                    ElevatedButton(
                      onPressed: () async {
                        bool isUpdated = await _saveProfile();
                        if (isUpdated) {
                          Get.to(() => ProfileView());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
