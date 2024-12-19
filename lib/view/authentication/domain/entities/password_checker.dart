import 'dart:ui';

import 'package:flutter/material.dart';

enum PasswordCheckerStatus { notFulfilled, fulfilled, error }

class PasswordChecker {
  String label;
  PasswordCheckerStatus status;
  Color fulfillmentColor = Colors.green;
  Color unfulfilledColor = Colors.grey;
  Color errorColor = Colors.grey;

  PasswordChecker(
      {required this.label, this.status = PasswordCheckerStatus.notFulfilled});
}
