class TrackedAntiSpoofCheckEntity {
  const TrackedAntiSpoofCheckEntity({
    required this.title,
    required this.description,
    required this.icon,
    required this.score,
  });

  final String title;
  final String description;
  final String icon;

  /// 0–100 score shown once the check has passed.
  final int score;
}
