import '../../../../../core/utils/app_exports.dart';

/// Placeholder for the Ai tab until its design is available.
class TrackedAiView extends StatelessWidget {
  const TrackedAiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.trackedAiComingSoon,
        style: context.bodyMediumStyle?.copyWith(
          fontSize: 14.sp,
          color: AppColors.signInDarkSubtitle,
        ),
      ),
    );
  }
}
