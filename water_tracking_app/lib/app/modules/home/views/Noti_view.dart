import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/controllers/notification_controller.dart'; // Import your controller
import 'package:water_tracking_app/app/modules/home/views/component/Tapbar.dart';

class NotiView extends StatelessWidget {
  final NotificationController notificationController = Get.put(NotificationController()); // Initialize the controller

  NotiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แจ้งเตือน'),
        backgroundColor: const Color.fromARGB(255, 132, 216, 255),
        centerTitle: true,
      ),
      body: NotificationPage(notificationController: notificationController),
      bottomNavigationBar: Tapbar(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  final NotificationController notificationController;

  const NotificationPage({super.key, required this.notificationController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: notificationController.notifications.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(notificationController.notifications[index].id), // Unique key for Dismissible
                onDismissed: (direction) {
                  notificationController.deleteNotification(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deleted Notification')),
                  );
                },
                background: Container(color: const Color.fromARGB(255, 255, 117, 107)),
                child: NotificationTile(
                  time: notificationController.notifications[index].time.format(context),
                  value: notificationController.notifications[index].isEnabled,
                  onChanged: (bool newValue) {
                    notificationController.toggleNotification(index, newValue);
                  },
                ),
              );
            },
          )),
        ),
        ElevatedButton(
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (pickedTime != null) {
              notificationController.addNotification(pickedTime, "your_user_id"); // Use the correct user ID
              print('Selected time: $pickedTime');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 174, 224, 189),
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
          ),
          child: const Text(
            'Add Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 5, 5, 5),
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
