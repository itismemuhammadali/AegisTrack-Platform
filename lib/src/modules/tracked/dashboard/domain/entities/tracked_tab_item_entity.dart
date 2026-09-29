class TrackedTabItemEntity {
  const TrackedTabItemEntity({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  /// Figma ships separate icons per state: [icon] already has the 60% muted
  /// stroke baked in, [activeIcon] is solid white — no tinting needed.
  final String icon;
  final String activeIcon;
  final String label;
}
