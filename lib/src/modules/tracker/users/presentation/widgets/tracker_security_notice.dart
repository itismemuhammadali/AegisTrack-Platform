import '../../../../../core/utils/app_exports.dart';

/// Tinted advisory panel used under the security checks.
class TrackerSecurityNotice extends StatelessWidget {
  const TrackerSecurityNotice(
      {super.key, required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .07),
          borderRadius: 20.circular,
          border: Border.all(color: color.withValues(alpha: .25)),
        ),
        child: child,
      );
}
