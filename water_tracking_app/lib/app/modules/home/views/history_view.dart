import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:water_tracking_app/app/modules/home/views/component/Tapbar.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water drinking history'),
        backgroundColor: Colors.lightBlue[100],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section: Water consumption list
            Text(
              'Water drinking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(child: _buildConsumptionList()),
          ],
        ),
      ),
      bottomNavigationBar: Tapbar(),
    );
  }


  /// Widget to display user's water consumption history
  Widget _buildConsumptionList() {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('waterIntake')
          .orderBy('timestamp', descending: true)  // เรียงจากล่าสุดไปเก่าสุด
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No water intake data available.'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Timestamp timestamp = doc['timestamp'];
            DateTime date = timestamp.toDate();
            int amount = doc['amount'];

            return ListTile(
              leading: Text(
                DateFormat('yyyy-MM-dd HH:mm').format(date),  // แสดงวันและเวลา
                style: TextStyle(fontSize: 18),
              ),
              trailing: Text(
                '$amount ml',  // แสดงปริมาณน้ำที่ดื่ม
                style: TextStyle(fontSize: 18),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
