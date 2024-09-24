import 'package:flutter/material.dart';
import 'package:water_tracking_app/add_weter.dart';
import 'package:water_tracking_app/cups_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return  MaterialApp(
      initialRoute: CupsPage.nameRoute,
      routes: {
        CupsPage.nameRoute: (context) => CupsPage(),
        AddWeter.nameRoute: (context) => AddWeter(),
      },
    );
  }
}