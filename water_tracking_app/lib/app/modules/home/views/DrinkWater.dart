import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore

class WaterTrack extends StatefulWidget {
  @override
  _WaterTrackState createState() => _WaterTrackState();
}

class _WaterTrackState extends State<WaterTrack> {
  double waterGoal = 0; // Default water goal

  @override
  void initState() {
    super.initState();
    // Retrieve the water goal passed as an argument and set the state
    final double? goalFromDrinkWater = Get.arguments;
    if (goalFromDrinkWater != null) {
      setState(() {
        waterGoal = goalFromDrinkWater; // Update the water goal
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Tracker'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Water Goal: $waterGoal ml',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Simulate a goal change for example purposes
                  setState(() {
                    waterGoal += 500; // Increase goal by 500 ml
                  });
                },
                child: Text('Increase Goal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
