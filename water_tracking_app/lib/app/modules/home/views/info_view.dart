import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class InfoView extends GetView<HomeController> {
  const InfoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InfoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ข้อมูลของคุณ',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}