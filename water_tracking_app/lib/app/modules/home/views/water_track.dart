import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:water_tracking_app/app/modules/home/views/add_weter.dart';

class WaterTrack extends StatelessWidget {
  static const String nameRoute = '/water_track';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'เป้าหมายการดื่มน้ำของคุณ',
          style:
              TextStyle(fontSize: 25, color: Color.fromARGB(255, 0, 94, 188)),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '2500 ml',
              style: TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 0, 94, 188),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 120,
              backgroundColor: Color.fromARGB(255, 15, 130, 245),
              child: Text(
                '100%',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 25.0), // เว้นระยะห่างจากขอบซ้ายและขวา
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle button click
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 236, 255, 165), // พื้นหลังปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize:
                          Size(150, 60), // กำหนดขนาดปุ่ม (width, height)
                    ),
                    child: Text(
                      'เป้าหมายใหม่',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                       Get.to(() => AddWeter());
                    },
                    backgroundColor: const Color.fromARGB(255, 149, 219, 173),
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // ให้แน่ใจว่ามีขอบโค้งเป็นวงกลม
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlue[50],
        iconSize: 35,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
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
