import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:water_tracking_app/app/modules/home/views/component/Tapbar.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Consumption History'),
        backgroundColor: Colors.lightBlue[100],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Today's consumption list
            Text(
              'Today',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(child: _buildTodayConsumptionList()),

            SizedBox(height: 20),
            Divider(color: Colors.grey),

            // Section 2: Weekly Bar Chart
            Text(
              'Week',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _buildWeeklyBarChart(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Tapbar(),
    );
  }

  // Widget to display today's water consumption in a list
  Widget _buildTodayConsumptionList() {
    final today = DateTime.now();

     return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('Waterintake')
        .where('timestamp', isGreaterThanOrEqualTo: DateTime(today.year, today.month, today.day))
        .where('timestamp', isLessThan: DateTime(today.year, today.month, today.day + 1))
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No data for today.'));
      }

        return ListView(
        children: snapshot.data!.docs.map((doc) {
          Timestamp timestamp = doc['timestamp'];
          DateTime date = timestamp.toDate();  // Convert Firestore timestamp to DateTime

          return ListTile(
            leading: Text(
              DateFormat('HH:mm').format(date),  // Format time from timestamp
              style: TextStyle(fontSize: 18),
            ),
            trailing: Text(
              '${doc['amount']} ml',
              style: TextStyle(fontSize: 18),
            ),
          );
        }).toList(),
        );
      },
    );
  }

  // Widget to display the weekly bar chart
  Widget _buildWeeklyBarChart() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('Waterintake')
        .where('timestamp', isGreaterThanOrEqualTo: startOfWeek)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No data available for this week.'));
      }


        final dailyData = _processFirebaseData(snapshot.data!.docs);

      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: dailyData,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(color: Colors.black, fontSize: 12);
                  Widget text;
                  switch (value.toInt()) {
                    case 0:
                      text = Text('Sun', style: style);
                      break;
                    case 1:
                      text = Text('Mon', style: style);
                      break;
                    case 2:
                      text = Text('Tue', style: style);
                      break;
                    case 3:
                      text = Text('Wed', style: style);
                      break;
                    case 4:
                      text = Text('Thu', style: style);
                      break;
                    case 5:
                      text = Text('Fri', style: style);
                      break;
                    case 6:
                      text = Text('Sat', style: style);
                      break;
                    default:
                      text = Text('');
                      break;
                  }
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 16,
                      child: text,
                    );
                  },
                  reservedSize: 42,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text(value.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 12));
                  },
                  interval: 500,
                  reservedSize: 32,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: true),
            gridData: FlGridData(show: false),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _processFirebaseData(
      List<QueryDocumentSnapshot> docs) {
    Map<int, double> waterData = {for (int i = 0; i < 7; i++) i: 0.0};

    docs.forEach((doc) {
      try {
        int dayOfWeek = (doc['dayOfWeek'] ?? 0) - 1;
        double amount = doc['amount'] != null ? doc['amount'].toDouble() : 0.0;
        waterData[dayOfWeek] = (waterData[dayOfWeek] ?? 0.0) + amount;
      } catch (e) {
        print("Error processing document: ${doc.id}");
      }
    });

    return waterData.entries
        .map(
          (entry) => BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                fromY: 0,
                toY: entry.value,
                color: Colors.lightBlue[100],
                width: 15,
              ),
            ],
          ),
        )
        .toList();
  }
}
