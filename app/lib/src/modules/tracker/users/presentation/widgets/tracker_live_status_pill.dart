import '../../../../../core/utils/app_exports.dart';

/// Rounded status pill with a leading dot, used for ONLINE / LIVE / OFFLINE.
class TrackerLiveStatusPill extends StatelessWidget {
  const TrackerLiveStatusPill({
    super.key,
    required this.label,
    required this.color,
    required this.fill,
    required this.border,
    this.showDot = true,
    this.horizontal = 12,
    this.vertical = 6,
    this.onMap = false,
  });

  final String label;
  final Color color;
  final Color fill;
  final Color? border;
  final bool showDot;
  final double horizontal;
  final double vertical;

  /// Pills sitting on the map blend their tint onto the map colour, so road
  /// labels underneath cannot read through them.
  final bool onMap;

  @override
  Widget build(BuildContext context) => Container(
        padding:
            AppInsets.symmetric(horizontal: horizontal, vertical: vertical),
        decoration: BoxDecoration(
          color:
              onMap ? Color.alphaBlend(fill, AppColors.trackerMapFill) : fill,
          borderRadius: 16.circular,
          border: border == null ? null : Border.all(color: border!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDot) ...[
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              6.pw,
            ],
            Text(
              label,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 16 / 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      );
}
