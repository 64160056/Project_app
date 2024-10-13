import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class ProfileView extends GetView<HomeController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.lightBlue[100],
        centerTitle: true,
      ),
       body: Center( // ทำให้เนื้อหาทั้งหมดอยู่ตรงกลาง
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // จัดเรียงตรงกลางในแนวตั้ง
            crossAxisAlignment: CrossAxisAlignment.center, // จัดเรียงตรงกลางในแนวนอน
            children: [
              // รูปโปรไฟล์
              Flexible(
                flex: 3,
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2, // ขนาดสมส่วน
                   backgroundImage: const AssetImage('assets/me.jpg'),
                
                  ),
                ),
              const SizedBox(height: 20),

              // ชื่อผู้ใช้
              const Flexible(
                flex: 1,
                child: Text(
                  'John Doe', // ชื่อผู้ใช้
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // อีเมลผู้ใช้
              Flexible(
                flex: 1,
                child: Text(
                  'john.doe@example.com', // อีเมล
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ปุ่มแก้ไขโปรไฟล์
              Flexible(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    // ทำงานเมื่อกดปุ่มแก้ไข
                    print('Edit Profile button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[200], // สีปุ่ม
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
       ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlue[50],
        iconSize: 35,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}