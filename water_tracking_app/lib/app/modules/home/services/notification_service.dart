import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_tracking_app/app/modules/home/controllers/notification.dart';
import 'package:water_tracking_app/app/modules/home/views/Noti_view.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications(BuildContext context) async {
    tz.initializeTimeZones(); // Initialize timezone data

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      if (notificationResponse.payload != null) {
        showNotificationDialog(
            context); // Show dialog when the notification is selected
      }
    });
  }

  Future<void> scheduleNotification(
      DateTime scheduledTime, String title, String body, {required int notificationId}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      sound: RawResourceAndroidNotificationSound(
          'your_sound_file'), // The sound you want to use
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Convert DateTime to TZDateTime
    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Use a unique notification ID for each notification
      title,
      body,
      tzScheduledTime,
      platformChannelSpecifics,
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // Use new variable
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'This is a notification payload', // Send payload
    );
  }

  // Update: Pass context to the method to use it for saving to Firestore
  Future<void> saveNotificationToFirestore(String userId, NotificationModel notification) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notification.id) // หรือ .doc(notification.notificationId) ถ้าต้องการ
        .set(notification.toMap());
  } catch (e) {
    print('Error saving notification: $e');
    throw e; // ส่งต่อข้อผิดพลาดไปยัง caller
  }
}


  Future<void> deleteNotificationFromFirestore(int notificationId) async {
    await _firestore
        .collection('users')
        .doc('userId')
        .collection('notifications')
        .doc(notificationId.toString())
        .delete();
  }

  void showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("แจ้งเตือน"),
        content: const Text("ถึงเวลาที่ตั้งไว้แล้ว โปรดดื่มน้ำ"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("ตกลง"),
          ),
        ],
      ),
    );
  }

  void cancelNotification(int notificationId) {}

  Future<List<NotificationModel>> fetchNotificationsFromFirestore(
      String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();
      List<NotificationModel> notifications = snapshot.docs.map((doc) {
        return NotificationModel(
          id: doc.id,
          message: doc[
              'message'], // Ensure this field exists in your Firestore document
          timestamp: (doc['timestamp'] as Timestamp).toDate(),
          isEnabled: doc['isEnabled'],
          time: TimeOfDay.fromDateTime(
              (doc['time'] as Timestamp).toDate()), // Parse TimeOfDay if saved
          notificationId: int.tryParse(doc['notificationId'].toString()) ??
              0, // Parse or set default
        );
      }).toList();
      return notifications;
    } catch (error) {
      throw Exception('Failed to fetch notifications: $error');
    }
  }
}
