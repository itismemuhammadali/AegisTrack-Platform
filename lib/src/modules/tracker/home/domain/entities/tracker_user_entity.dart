enum TrackerAuthenticity { verified, acceptable, questionable, suspect }

class TrackerUserEntity {
  const TrackerUserEntity({
    required this.name,
    required this.lastSeen,
    required this.location,
    required this.authenticity,
    this.isOnline = true,
    this.isSos = false,
    this.isIdentified = true,
  });

  final String name;
  final String lastSeen;
  final String location;
  final TrackerAuthenticity authenticity;
  final bool isOnline;
  final bool isSos;

  /// An unidentified subject: the overview has no history to show, so its
  /// metrics read Unknown / N/A.
  final bool isIdentified;
}
