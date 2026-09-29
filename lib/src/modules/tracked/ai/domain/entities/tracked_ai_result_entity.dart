import 'package:flutter/material.dart';

class TrackedAiResultEntity {
  const TrackedAiResultEntity({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  final String icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final String timestamp;
}
