import 'package:flutter/material.dart';
import 'package:water_tracking_app/add_weter.dart';
import 'package:water_tracking_app/register.dart';
import 'package:water_tracking_app/LoginPage.dart';
// นำเข้าหน้าอื่น ๆ ที่จำเป็น

class CupsPage extends StatefulWidget {
  static const String nameRoute = '/cups_page';
  const CupsPage({Key? key}) : super(key: key);

  @override
  _CupsPageState createState() => _CupsPageState();
}

class _CupsPageState extends State<CupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cups Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AddWeter.nameRoute);
            },
            child: const Text('ไปที่ Add Weter'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, RegisterPage.nameRoute);
            },
            child: const Text('ไปที่ Register'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginPage.nameRoute);
            },
            child: const Text('ไปที่ Login'),
          ),
          // เพิ่มปุ่มสำหรับหน้าอื่น ๆ
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/target_water'); // เส้นทางอื่นๆ
            },
            child: const Text('ไปที่ Target Water'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile'); // เส้นทางอื่นๆ
            },
            child: const Text('ไปที่ Profile'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/drink'); // เส้นทางอื่นๆ
            },
            child: const Text('ไปที่ Drink'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/report'); // เส้นทางอื่นๆ
            },
            child: const Text('ไปที่ Report'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notification'); // เส้นทางอื่นๆ
            },
            child: const Text('ไปที่ Notification'),
          ),
        ],
      ),
    );
  }
}
