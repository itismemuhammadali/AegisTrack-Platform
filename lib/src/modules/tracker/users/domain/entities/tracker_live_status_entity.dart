/// A location ping on the live tracking feed.
class TrackerLivePingEntity {
  const TrackerLivePingEntity({required this.time, required this.location});

  final String time;
  final String location;
}

/// One of the two summary cards under the live location.
class TrackerLiveStatEntity {
  const TrackerLiveStatEntity({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  final String label;
  final String value;
  final String subtitle;
}
