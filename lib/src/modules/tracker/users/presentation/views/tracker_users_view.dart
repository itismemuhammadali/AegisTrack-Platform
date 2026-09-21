import '../../../../../core/utils/app_exports.dart';

/// Users tab — design pending.
class TrackerUsersView extends StatelessWidget {
  const TrackerUsersView({super.key});

  @override
  Widget build(BuildContext context) => const TrackerTabPlaceholder(
        label: AppStrings.trackerNavUsers,
      );
}

class TrackerTabPlaceholder extends StatelessWidget {
  const TrackerTabPlaceholder({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label — ${AppStrings.trackerComingSoon}',
        style: context.bodyMediumStyle?.copyWith(
          fontSize: 14.sp,
          color: AppColors.signInDarkSubtitle,
        ),
      ),
    );
  }
}
