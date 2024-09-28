import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';

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
class WaterVolumeScreen extends StatefulWidget {
  @override
  _WaterVolumeScreenState createState() => _WaterVolumeScreenState();
}

class _WaterVolumeScreenState extends State<WaterVolumeScreen> {
  final List<Map<String, dynamic>> volumes = [
    {'label': '50 ml', 'image': 'assets/water_bottle.png', 'amount': 50},
    {'label': '100 ml', 'image': 'assets/water_bottle.png', 'amount': 100},
    {'label': '150 ml', 'image': 'assets/water_bottle.png', 'amount': 150},
    {'label': '200 ml', 'image': 'assets/water_bottle.png', 'amount': 200},
    {'label': '250 ml', 'image': 'assets/water_bottle.png', 'amount': 250},
    {'label': 'กำหนดเอง', 'image': 'assets/water_bottle.png'},
  ];

   int selectedAmount = 0; // ปริมาณน้ำที่ถูกเลือก


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
                  onTap: () async {
                    if (volumes[index]['label'] == 'กำหนดเอง') {
                      showCustomAmountDialog(context);
                    } else {
                      Get.to(() => WaterTrack());
                      Navigator.pop(context, volumes[index]['amount']);
                    }
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
void showCustomAmountDialog(BuildContext context) {
  final TextEditingController _controller = TextEditingController();
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/wavedialog.png'), // ใส่ path ของรูปพื้นหลังที่ต้องการ
              fit: BoxFit.cover, // ให้รูปเต็มพื้นที่
            ),
            borderRadius: BorderRadius.circular(20), // ขอบมนของ container
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'กำหนดเอง',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 13, 13, 13), // เปลี่ยนสีเพื่อให้เด่นบนพื้นหลัง
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: TextStyle(color: const Color.fromARGB(255, 127, 127, 127)), // เปลี่ยนสี hint ให้เข้ากับพื้นหลัง
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(color: const Color.fromARGB(255, 7, 7, 7)), // เปลี่ยนสีข้อความที่พิมพ์
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'ml.',
                      style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)), // เปลี่ยนสีให้เข้ากับพื้นหลัง
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print('Added ${_controller.text} ml');
                    Navigator.of(context).pop(); // ปิด dialog
                    Get.to(() => WaterTrack());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 136, 195, 130),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
