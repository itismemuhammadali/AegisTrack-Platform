enum TrackerAuthenticity { verified, acceptable, questionable }

class TrackerUserEntity {
  const TrackerUserEntity({
    required this.name,
    required this.lastSeen,
    required this.location,
    required this.authenticity,
    this.isOnline = true,
    this.isSos = false,
  });

  final String name;
  final String lastSeen;
  final String location;
  final TrackerAuthenticity authenticity;
  final bool isOnline;
  final bool isSos;
}
