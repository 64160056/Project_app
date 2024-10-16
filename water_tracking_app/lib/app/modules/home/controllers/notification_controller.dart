import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:water_tracking_app/app/modules/home/services/notification_service.dart';
import 'notification.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  final NotificationService notificationService = NotificationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    notificationService
        .initNotifications(Get.context!); // Initialize notifications
    // Consider passing a user ID here if necessary
    fetchNotifications("your_user_id"); // Fetch initial notifications
  }

  Future<void> fetchNotifications(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      notifications.value = querySnapshot.docs
          .map((doc) =>
              NotificationModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  void addNotification(TimeOfDay time, String userId) {
    String notificationId =
        DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID
    var newNotification = NotificationModel(
      id: notificationId,
      message: 'Time to drink water!',
      timestamp: DateTime.now(),
      time: time,
      isEnabled: false,
      notificationId:
          notificationId.hashCode, // Generate unique ID for notification
    );

    notifications.add(newNotification); // Add new notification

    // Save to Firestore
    _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId) // ใช้ ID ที่สร้างขึ้น
        .set(newNotification.toMap())
        .then((_) {
      Get.snackbar('Success', 'Notification added successfully');
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to add notification: $error');
    });
  }

  void toggleNotification(int index, bool value) {
    notifications[index].isEnabled = value;

    if (value) {
      scheduleNotification(index);
    } else {
      cancelNotification(
          notifications[index].notificationId); // Use notificationId to cancel
    }
  }

  void scheduleNotification(int index) {
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

    notificationService
        .scheduleNotification(
      scheduledTime,
      'แจ้งเตือนดื่มน้ำ',
      'ได้เวลาที่ตั้งไว้แล้ว โปรดดื่มน้ำ',
      notificationId:
          notifications[index].notificationId, // Pass the unique ID here
    )
        .then((_) {
      Get.snackbar('Success', 'Notification scheduled successfully');
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to schedule notification: $error');
    });
  }

  void cancelNotification(int notificationId) {
    if (notificationId != null) {
      notificationService
          .cancelNotification(notificationId); // Use service method to cancel
    }
  }

  void deleteNotification(int index) {
    // ลบการแจ้งเตือนจาก Firestore
    var notificationId = notifications[index].id;
    notifications.removeAt(index);
    _firestore
        .collection('users')
        .doc('your_user_id') // แทนที่ด้วย user ID ที่ถูกต้อง
        .collection('notifications')
        .doc(notificationId)
        .delete()
        .then((_) {
      Get.snackbar('Success', 'Notification deleted successfully');
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to delete notification: $error');
    });
  }
}
