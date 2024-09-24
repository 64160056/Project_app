import 'package:flutter/material.dart';
import 'package:water_tracking_app/LoginPage.dart';
import 'package:water_tracking_app/register.dart'; // นำเข้าหน้าใหม่
import 'package:water_tracking_app/add_weter.dart';
import 'package:water_tracking_app/cups_page.dart';
import 'package:water_tracking_app/water_track.dart';
// นำเข้าไฟล์ของหน้าอื่นๆ ด้วย

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: CupsPage.nameRoute,
      routes: {
        CupsPage.nameRoute: (context) => CupsPage(),
        AddWeter.nameRoute: (context) => AddWeter(),
        RegisterPage.nameRoute: (context) => RegisterPage(), // เส้นทางใหม่
        LoginPage.nameRoute: (context) => LoginPage(), // เส้นทางใหม่
        WaterTrack.nameRoute: (context) => WaterTrack(),
        // เพิ่มเส้นทางสำหรับหน้าอื่นๆ
      },
    );
  }
}
