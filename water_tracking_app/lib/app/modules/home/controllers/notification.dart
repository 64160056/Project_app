import 'package:flutter/material.dart';

class NotificationModel {
  String id; // Unique ID for the notification
  String message; // Notification message
  DateTime timestamp; // Date and time of the notification
  TimeOfDay time; // Time of the notification
  bool isEnabled; // Is the notification enabled?
  int notificationId; // Notification ID for scheduling

  NotificationModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.time,
    this.isEnabled = false,
    required this.notificationId,
  });

  // Optionally, you can add a method to convert to a map for Firestore saving
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'time': {'hour': time.hour, 'minute': time.minute}, // Save time in a map
      'isEnabled': isEnabled,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      time: TimeOfDay(hour: map['time']['hour'], minute: map['time']['minute']), // Extract hour and minute
      isEnabled: map['isEnabled'] ?? false,
      notificationId: map['notificationId'],
    );
  }
}

  


