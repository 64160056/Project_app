import 'package:flutter/material.dart';
import 'package:water_tracking_app/add_weter.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // กดตั้งเป้าหมายใหม่
                  },
                  child: Text('เป้าหมายใหม่'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AddWeter.nameRoute);
                  },
                  
                  
                  child: Icon(Icons.add,color: Color.fromARGB(255, 22, 27, 19), ),
                ),
              ],
            ),
          ],
        ),
      ),
      
    );
  }
}
