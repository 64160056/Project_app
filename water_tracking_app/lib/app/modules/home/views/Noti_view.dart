import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/services/notification_service.dart';
import 'package:water_tracking_app/app/modules/home/views/profile_view.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';

class NotiView extends StatelessWidget {
  final NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    notificationService
        .initNotifications(context); // เรียกใช้ initNotifications
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('แจ้งเตือน'),
          backgroundColor: Colors.lightBlue[100],
          centerTitle: true,
        ),
        body: NotificationPage(notificationService: notificationService),
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

  // Function to select time
  void selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      addNotificationTime(pickedTime); // Add the picked time to notifications
      print('Selected time: $pickedTime');
    }
  }

  void addNotificationTime(TimeOfDay time) {
    setState(() {
      notifications.add(Notification(time: time)); // Add new notification
    });
  }

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

      // ถ้าเวลาที่เลือกอยู่ก่อนเวลาปัจจุบัน ให้เลื่อนไปวันถัดไป
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(Duration(days: 1));
      }

      widget.notificationService.scheduleNotification(
        scheduledTime,
        'แจ้งเตือนดื่มน้ำ',
        'ได้เวลาที่ตั้งไว้แล้ว โปรดดื่มน้ำ',
      );
    } else {
      // Logic to cancel the notification can be added here
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
          onPressed:
              selectTime, // Trigger selectTime when the button is pressed
          child: Text(
            'Add Notification Time',
            style: TextStyle(
              fontSize: 18, // ขนาดฟอนต์
              fontWeight: FontWeight.bold, // น้ำหนักฟอนต์
              color: const Color.fromARGB(255, 5, 5, 5), // สีฟอนต์
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 174, 224, 189), // สีพื้นหลัง
            padding: EdgeInsets.symmetric(
                vertical: 16.0, horizontal: 32.0), // การจัดการ padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // มุมของปุ่ม
            ),
            elevation: 5, // ความสูงของเงา
          ),
        ),
        SizedBox(height: 16,)
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
