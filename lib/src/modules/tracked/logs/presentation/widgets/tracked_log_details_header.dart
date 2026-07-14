import '../../../../../core/utils/app_exports.dart';

class TrackedLogDetailsHeader extends StatelessWidget {
  const TrackedLogDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.symmetric(horizontal: 24, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: AppRouterGo.back,
              child: Container(
                width: 40.w,
                height: 40.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite.withValues(alpha: 0.05),
                  borderRadius: 18.circular,
                  border: Border.all(
                    color: AppColors.primaryWhite.withValues(alpha: 0.1),
                  ),
                ),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedLogDetailsBack,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            ),
          ),
          Text(
            AppStrings.trackedLogDetailsTitle,
            style: context.titleLargeStyle?.copyWith(
              color: AppColors.primaryWhite,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
