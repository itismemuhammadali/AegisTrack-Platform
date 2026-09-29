import '../../../../../core/utils/app_exports.dart';

class TrackedSyncStatusLogCard extends StatelessWidget {
  const TrackedSyncStatusLogCard({
    required this.child,
    required this.borderColor,
    super.key,
  });

  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}
