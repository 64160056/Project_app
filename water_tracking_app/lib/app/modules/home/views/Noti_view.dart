import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/services/notification_service.dart';
import 'package:water_tracking_app/app/modules/home/views/component/Tapbar.dart';
import 'package:water_tracking_app/app/modules/home/views/history_view.dart';
import 'package:water_tracking_app/app/modules/home/views/profile_view.dart';
import 'package:water_tracking_app/app/modules/home/views/water_track.dart';

class NotiView extends StatelessWidget {
  final NotificationService notificationService = NotificationService();

  NotiView({super.key});

  @override
  Widget build(BuildContext context) {
    notificationService.initNotifications(context); // Initialize notifications
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('แจ้งเตือน'),
          backgroundColor: const Color.fromARGB(255, 132, 216, 255),
          centerTitle: true,
        ),
        body: NotificationPage(notificationService: notificationService),
        bottomNavigationBar: Tapbar(),
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

  const NotificationPage({super.key, required this.notificationService});

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

      // If the selected time is before the current time, schedule for the next day
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      widget.notificationService.scheduleNotification(
        scheduledTime,
        'แจ้งเตือนดื่มน้ำ',
        'ได้เวลาที่ตั้งไว้แล้ว โปรดดื่มน้ำ',
      ).catchError((error) {
        print('Error scheduling notification: $error');
      });
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
            padding: const EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(notifications[index].time.toString()),
                onDismissed: (direction) {
                  deleteNotification(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deleted Notification')),
                  );
                },
                background: Container(color: const Color.fromARGB(255, 255, 117, 107)),
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
          onPressed: selectTime,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 174, 224, 189), // Background color
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Button corner radius
            ),
            elevation: 5, // Shadow height
          ),
          child: Text(
            'Add Time',
            style: TextStyle(
              fontSize: 18, // Font size
              fontWeight: FontWeight.bold, // Font weight
              color: const Color.fromARGB(255, 5, 5, 5), // Font color
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String time;
  final bool value;
  final Function(bool) onChanged;

  const NotificationTile({
    super.key,
    required this.time,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 157, 222, 251),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: const TextStyle(fontSize: 18),
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
