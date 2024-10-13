import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class EditprofileView extends GetView<HomeController> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://example.com/profile-picture.jpg', // สามารถเปลี่ยนเป็นรูปผู้ใช้
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    // ฟังก์ชันสำหรับอัพโหลดรูปภาพใหม่
                  },
                  child: Text(
                    'Change Profile Picture',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // ชื่อผู้ใช้
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              // อีเมล
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              // รหัสผ่าน
              // TextField(
              //   controller: _passwordController,
              //   keyboardType: TextInputType.password,
              //   decoration: InputDecoration(
              //     labelText: 'Password',
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(Icons.password),
              //   ),
              // ),
              SizedBox(height: 40),
              // ปุ่มบันทึกข้อมูล
              ElevatedButton(
                onPressed: () {
                  // ฟังก์ชันสำหรับบันทึกข้อมูลโปรไฟล์
                  _saveProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    // ฟังก์ชันสำหรับบันทึกข้อมูลโปรไฟล์
    String name = _nameController.text;
    String email = _emailController.text;
     String email = _emailController.text;

    // ตรวจสอบและบันทึกข้อมูล
    print("Name: $name");
    print("Email: $email");

  }
}