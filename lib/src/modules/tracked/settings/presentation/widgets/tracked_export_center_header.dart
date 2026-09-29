import '../../../../../core/utils/app_exports.dart';

class TrackedExportCenterHeader extends StatelessWidget {
  const TrackedExportCenterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.only(left: 24, right: 24, top: 24, bottom: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: AppBackButton(),
          ),
          Text(
            AppStrings.trackedSettingsExportCenter,
            style: context.titleLargeStyle?.copyWith(
              color: AppColors.primaryWhite,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 20,
            ),
          ),
        ],
      ),
    );
  }
}
