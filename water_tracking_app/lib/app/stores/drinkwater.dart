import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void addWaterIntakeData(String time, int amount) {
  // Getting current date and day of week
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  int dayOfWeek = now.weekday % 7; // Monday is 1, Sunday is 7, adjust to 0 (Sun) to 6 (Sat)

  // Creating data structure to store in Firestore
  Map<String, dynamic> waterIntakeData = {
    "time": time, // Example "09:00"
    "amount": amount, // Example 250 ml
    "dayOfWeek": dayOfWeek, // Example Monday = 1
    "date": formattedDate // Example "2024-10-14"
  };

  // Adding data to Firestore collection
  FirebaseFirestore.instance.collection('waterIntake').add(waterIntakeData)
    .then((value) => print('Data Added Successfully'))
    .catchError((error) => print('Failed to add data: $error'));
}
