import '../../../../../core/utils/app_exports.dart';

class TrackedLogsView extends StatelessWidget {
  const TrackedLogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.trackedNavLogs,
        style: context.titleMediumStyle?.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryWhite,
        ),
      ),
    );
  }
}
