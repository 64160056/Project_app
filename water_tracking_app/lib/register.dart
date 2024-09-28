// register.dart
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  static const String nameRoute = '/register';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.lightBlue, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          // ฟิลด์สำหรับกรอกชื่อ
                          const TextField(
                            style: TextStyle(color: Colors.lightBlue),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.lightBlue, // เปลี่ยนสีขอบเป็นสีฟ้า
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.blue, // เปลี่ยนสีขอบเมื่อโฟกัสเป็นสีฟ้าเข้ม
                                  ),
                                ),
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.lightBlue), // เปลี่ยนสี hint text เป็นฟ้า
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                )),
                          ),
                          SizedBox(height: 30),
                          
                          // ฟิลด์สำหรับกรอกอีเมล
                          const TextField(
                            style: TextStyle(color: Colors.lightBlue),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.lightBlue, // เปลี่ยนสีขอบเป็นสีฟ้า
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.blue, // เปลี่ยนสีขอบเมื่อโฟกัสเป็นสีฟ้าเข้ม
                                  ),
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.lightBlue), // เปลี่ยนสี hint text เป็นฟ้า
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                )),
                          ),
                          SizedBox(height: 30),

                          // ฟิลด์สำหรับกรอกรหัสผ่าน
                          const TextField(
                            style: TextStyle(color: Colors.lightBlue),
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.lightBlue, // เปลี่ยนสีขอบเป็นสีฟ้า
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.blue, // เปลี่ยนสีขอบเมื่อโฟกัสเป็นสีฟ้าเข้ม
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.lightBlue), // เปลี่ยนสี hint text เป็นฟ้า
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                )),
                          ),
                          SizedBox(height: 40),
                          
                          // แถวปุ่ม 'Sign Up' และปุ่มลูกศร
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.blue, // เปลี่ยนพื้นหลังปุ่มเป็นสีฟ้าเข้ม
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    // เพิ่มฟังก์ชันการทำงานเมื่อลงทะเบียน
                                  },
                                  icon: const Icon(Icons.arrow_forward),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 40),

                          // แถวปุ่ม 'Sign In'
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'login'); // นำไปยังหน้า login
                                },
                                child: const Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.lightBlue,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
