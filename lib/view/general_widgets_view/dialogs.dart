  import 'package:flutter/material.dart';
import 'package:gifts_app/model/classes/notification.dart' as CustomNotifications;

void showNotificationDialog(BuildContext context, CustomNotifications.Notification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Text(notification.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
