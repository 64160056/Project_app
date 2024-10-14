import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null; // Handle error as needed
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot snapshot = await _db.collection('users').doc(uid).get();
    return snapshot.data() as Map<String, dynamic>?;
  }
}

class AuthController extends GetxController {
  var user = Rx<User?>(null);
  var userData = Rx<Map<String, dynamic>?>(null); // To hold user data
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  // Login method
  void login(String email, String password) async {
    user.value = await _authService.signInWithEmail(email, password);
    if (user.value != null) {
      // Fetch user data after successful login
      userData.value = await _userService.getUserData(user.value!.uid);
    } else {
      // Handle login failure (show error message)
      Get.snackbar("Login Failed", "Please check your credentials.");
    }
  }

  // Logout method
  void logout() async {
    await _authService.signOut();
    user.value = null; // Clear user state
    userData.value = null; // Clear user data
  }
}
