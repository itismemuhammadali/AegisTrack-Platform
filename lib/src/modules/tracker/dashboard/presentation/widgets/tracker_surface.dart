import '../../../../../core/utils/app_exports.dart';

/// Shared translucent surface used throughout the viewer portal.
class TrackerSurface extends StatelessWidget {
  const TrackerSurface(
      {super.key, required this.child, this.padding = 16, this.borderColor});
  final Widget child;
  final double padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .05),
          borderRadius: 16.circular,
          border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: .1)),
        ),
        child: child,
      );
}

class TrackerBadge extends StatelessWidget {
  const TrackerBadge(this.label,
      {super.key,
      this.color = Colors.white,
      this.background,
      this.horizontal = 8});
  final String label;
  final Color color;
  final Color? background;
  final double horizontal;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.symmetric(horizontal: horizontal, vertical: 3),
        decoration: BoxDecoration(
            color: background ?? color.withValues(alpha: .1),
            borderRadius: 100.circular),
        child: Text(label,
            style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp, fontWeight: FontWeight.w500, color: color)),
      );
}

class TrackerSectionTitle extends StatelessWidget {
  const TrackerSectionTitle(this.title,
      {super.key, this.mutedSubtitle = false});
  final String title;
  final bool mutedSubtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: context.titleMediumStyle?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          6.ph,
          Text('12 users · Read-Only Access',
              style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color:
                      mutedSubtitle ? const Color(0xff8ba9a3) : Colors.white)),
        ],
      );
}
