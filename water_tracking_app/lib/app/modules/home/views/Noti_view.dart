import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/services/notification_service.dart';
import 'package:water_tracking_app/app/modules/home/views/profile_view.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';

class NotiView extends StatelessWidget {
  final NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('แจ้งเตือน'),
          backgroundColor: Colors.lightBlue[100],
          centerTitle: true,
        ),
        body: NotificationPage(notificationService: notificationService),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (pickedTime != null) {
              DateTime now = DateTime.now();
              DateTime scheduledTime = DateTime(
                now.year,
                now.month,
                now.day,
                pickedTime.hour,
                pickedTime.minute,
              );

              await notificationService.scheduleNotification(
                scheduledTime,
                'แจ้งเตือนดื่มน้ำ',
                'ได้เวลาที่ตั้งไว้แล้ว โปรดดื่มน้ำ',
              );

              print('Scheduled at: $scheduledTime');
            }
          },
          backgroundColor: const Color.fromARGB(255, 158, 240, 253),
          child: Icon(
            Icons.add,
            size: 30,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.lightBlue[50],
          iconSize: 35,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              Get.to(() => WaterTrack());
            } else if (index == 1) {
              // Handle history page
            } else if (index == 2) {
              Get.to(() => NotiView());
            } else if (index == 3) {
              Get.to(() => ProfileView());
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.water_drop),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

class Notification {
  TimeOfDay time;
  bool isEnabled;

  Notification({required this.time, this.isEnabled = false});
}

class NotificationPage extends StatefulWidget {
  final NotificationService notificationService;

  NotificationPage({required this.notificationService});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notification> notifications = [];

  void toggleSwitch(bool value, int index) {
    setState(() {
      notifications[index].isEnabled = value;
    });

    if (value) {
      DateTime now = DateTime.now();
      DateTime scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        notifications[index].time.hour,
        notifications[index].time.minute,
      );

      widget.notificationService.scheduleNotification(
        scheduledTime,
        'แจ้งเตือนดื่มน้ำ',
        'ได้เวลาที่ตั้งไว้แล้ว โปรดดื่มน้ำ',
      );
    } else {
      // Here you can implement logic to cancel the notification
    }
  }

  Future<void> selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        notifications.add(Notification(time: pickedTime)); // Add new notification
      });
    }
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index); // Remove the notification
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(notifications[index].time.toString()),
                onDismissed: (direction) {
                  deleteNotification(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted Notification')),
                  );
                },
                background: Container(color: Colors.red),
                child: NotificationTile(
                  time: notifications[index].time.format(context),
                  value: notifications[index].isEnabled,
                  onChanged: (bool newValue) {
                    toggleSwitch(newValue, index);
                  },
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: selectTime, // Trigger selectTime when the button is pressed
          child: Text('Add Notification Time'),
        ),
      ],
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String time;
  final bool value;
  final Function(bool) onChanged;

  NotificationTile({
    required this.time,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 18),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
