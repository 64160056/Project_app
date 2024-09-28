import 'package:flutter/material.dart';

class AddWeter extends StatelessWidget {
  static const String nameRoute = '/add_weter';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: Scaffold(
        appBar: AppBar(
          title: Text('ปริมาณการดื่ม',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.lightBlue[100],
          centerTitle: true,
        ),
        body: WaterVolumeScreen(),
      ),
    );
  }
}

class WaterVolumeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> volumes = [
    {'label': '50 ml', 'image': 'assets/water_bottle.png'},
    {'label': '100 ml', 'image': 'assets/water_bottle.png'},
    {'label': '150 ml', 'image': 'assets/water_bottle.png'},
    {'label': '200 ml', 'image': 'assets/water_bottle.png'},
    {'label': '250 ml', 'image': 'assets/water_bottle.png'},
    {'label': 'กำหนดเอง', 'image': 'assets/water_bottle.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          
          
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true, // ทำให้ GridView ขยายเท่าที่จำเป็น
              physics: NeverScrollableScrollPhysics(), 
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // จำนวนปุ่มในแต่ละแถว
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              itemCount: volumes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Handle click event
                    print('Selected: ${volumes[index]['label']}');
                  },
                  child: Column(
                    children: [
                      // ปุ่มที่เป็นวงกลมพร้อมเงา
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // รูปทรงวงกลม
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // สีของเงา
                              spreadRadius: 2, // ระยะกระจายของเงา
                              blurRadius: 5, // ระยะเบลอของเงา
                              offset: Offset(0, 3), // การเลื่อนของเงา (x, y)
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40, // ขนาดของปุ่ม
                          backgroundImage: AssetImage(volumes[index]['image']),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        volumes[index]['label'],
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          height: 150, // ความสูงของคลื่นน้ำที่ด้านล่าง
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset('assets/wave.png', fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
