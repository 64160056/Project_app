import 'package:flutter/material.dart';
import 'package:water_tracking_app/add_weter.dart';

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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AddWeter.nameRoute);
          },
          child: const Text('ไปที่ Add Weter'),
        ),
      ),
    );
  }
}