import 'package:flutter/material.dart';

class AddWeter extends StatelessWidget {
  static const String nameRoute = '/add_weter';

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'เพิ่มข้อมูลของคุณ';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: const Center(
        child: Text('Hello Worldddddddddd'),
      ),
    );
  }
}