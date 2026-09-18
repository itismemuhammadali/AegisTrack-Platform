import 'package:flutter/material.dart';

class TrackedZoneEventEntity {
  const TrackedZoneEventEntity({
    required this.title,
    required this.zone,
    required this.time,
    required this.coordinates,
    required this.color,
  });

  final String title;
  final String zone;
  final String time;
  final String coordinates;
  final Color color;
}
