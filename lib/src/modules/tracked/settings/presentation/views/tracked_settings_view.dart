import '../../../../../core/utils/app_exports.dart';

class TrackedSettingsView extends StatelessWidget {
  const TrackedSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.trackedNavSettings,
        style: context.titleMediumStyle?.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryWhite,
        ),
      ),
    );
  }
}
