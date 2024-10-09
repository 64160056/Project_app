import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this to your pubspec.yaml

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaterConsumptionHomePage();
  }
}

class WaterConsumptionHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการดื่มน้ำ'), // Title in Thai
        backgroundColor: Colors.lightBlue[100],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Week',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Sun';
                              break;
                            case 1:
                              text = 'Mon';
                              break;
                            case 2:
                              text = 'Tue';
                              break;
                            case 3:
                              text = 'Wed';
                              break;
                            case 4:
                              text = 'Thu';
                              break;
                            case 5:
                              text = 'Fri';
                              break;
                            case 6:
                              text = 'Sat';
                              break;
                            default:
                              return Container();
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0, // space between bar and title
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: Colors.grey)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 6, color: Colors.grey[700])]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 3, color: Colors.grey[600])]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 7, color: Colors.grey[500])]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 8, color: Colors.grey[400])]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 9, color: Colors.grey[300])]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 5, color: Colors.grey[200])]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          color: Colors.lightBlue[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.history, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.info, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
