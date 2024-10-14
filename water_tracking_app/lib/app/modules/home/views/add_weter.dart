import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';

class AddWeter extends StatelessWidget {
  static const String nameRoute = '/add_weter';

  const AddWeter({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Drinking amount',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.lightBlue[100],
          centerTitle: true,
        ),
        body: WaterVolumeScreen(),
      ),
    );
  }
}

class WaterVolumeScreen extends StatefulWidget {
  const WaterVolumeScreen({super.key});

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
          padding: const EdgeInsets.all(16.0),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true, // ทำให้ GridView ขยายเท่าที่จำเป็น
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      int selectedAmount =
                          int.parse(volumes[index]['label'].split(' ')[0]);
                      Get.back(
                          result: selectedAmount); // ส่งค่ากลับไปที่ WaterTrack
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
                              offset:
                                  const Offset(0, 3), // การเลื่อนของเงา (x, y)
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40, // ขนาดของปุ่ม
                          backgroundImage: AssetImage(volumes[index]['image']),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        volumes[index]['label'],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
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
  final TextEditingController controller = TextEditingController();

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
            image: const DecorationImage(
              image: AssetImage('assets/wavedialog.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'customized',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 13, 13, 13),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 127, 127, 127)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 7, 7, 7)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'ml.',
                      style: TextStyle(
                          fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final amount = int.tryParse(controller.text);
                    if (amount == null || amount <= 0) {
                      Get.snackbar('Error',
                          'Please enter a valid amount greater than zero.',
                          snackPosition: SnackPosition.BOTTOM);
                      return; // Exit if invalid
                    }
                    Navigator.of(context).pop(amount); // Send value back
                    Get.back(result: amount);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 136, 195, 130),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // rest of the code...
                    ),
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
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
