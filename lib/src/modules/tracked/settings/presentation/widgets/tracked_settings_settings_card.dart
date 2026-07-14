import '../../../../../core/utils/app_exports.dart';

class TrackedSettingsSettingsCard extends StatelessWidget {
  const TrackedSettingsSettingsCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(color: AppColors.trackedSettingsCardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final child in children) ...[
            child,
            if (child != children.last)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.trackedSettingsCardBorder,
              ),
          ],
        ],
      ),
    );
  }
}
