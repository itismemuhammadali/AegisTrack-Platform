import 'package:flutter/material.dart';

class TrackerAlertEntity {
  const TrackerAlertEntity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String time;
  final String icon;
  final Color color;
}
