import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for additional user data
import 'package:water_tracking_app/app/modules/home/services/auth_service.dart';
import 'package:water_tracking_app/app/modules/home/views/component/Tapbar.dart';
import 'editprofile_view.dart'; // Import your EditProfileView
// Make sure to import your UserService class

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService(); // Initialize UserService

  User? _user;
  String _name = '';
  String _email = '';
  String _profilePictureUrl = 'assets/profile.png'; // Default profile image
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        // Fetch the user data using UserService
        Map<String, dynamic>? userData =
            await _userService.getUserData(_user!.uid);

        setState(() {
          if (userData != null) {
            // Safely check if the fields exist before accessing them
            _name = userData['username'] ?? 'No Name';
            _email = _user!.email ?? 'No Email';
            _profilePictureUrl =
                userData['profilePictureUrl'] ?? 'assets/profile.png';
          } else {
            print('User document does not exist');
            _name = 'No Name';
          }
          _isLoading = false; // Stop loading when data is fetched
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false; // Stop loading spinner in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.lightBlue[100],
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while fetching data
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture
                    Flexible(
                      flex: 3,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width *
                            0.2, // Scaled size
                        backgroundImage: _profilePictureUrl.contains('http')
                            ? NetworkImage(_profilePictureUrl)
                            : AssetImage(_profilePictureUrl) as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // User's Name
                    Flexible(
                      flex: 1,
                      child: Text(
                        _name, // Display fetched user name
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // User's Email
                    Flexible(
                      flex: 1,
                      child: Text(
                        _email, // Display fetched email
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Edit Profile Button
                    Flexible(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => EditProfileView());
                          print('Edit Profile button pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.lightBlue[200], // Button color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 18, // Font size for the text
                            color: Colors.black, // Set the text color to black
                          ),
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
