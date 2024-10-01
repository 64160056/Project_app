import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyAqoEMIAgTeaCWRR7jHCP4o08bfbcYDaqE', // แทนที่ด้วย API Key ที่คุณได้รับจาก Firebase
  appId: '1:339008003107:android:c676f86edc2ca19b43a596', // แทนที่ด้วย App ID ที่คุณได้รับจาก Firebase
  messagingSenderId: '339008003107', // แทนที่ด้วย Sender ID ที่คุณได้รับจาก Firebase
  projectId: 'warter-track-data', // แทนที่ด้วย Project ID ที่คุณได้รับจาก Firebase
  //databaseURL: 'YOUR_DATABASE_URL', // ถ้ามี
);

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized(); // Ensure that the binding is initialized

  try {
    await Firebase.initializeApp(options: firebaseOptions); // Initialize Firebase with options
  } catch (e) {
    print("Firebase initialization error: $e"); // พิมพ์ข้อผิดพลาดในคอนโซล
    return; // ออกจาก main หากไม่สามารถเริ่ม Firebase ได้
  }
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
