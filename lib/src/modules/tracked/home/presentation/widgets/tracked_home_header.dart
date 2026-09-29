import '../../../../../core/utils/app_exports.dart';

class TrackedHomeHeader extends StatelessWidget {
  const TrackedHomeHeader({super.key, this.onSos});

  final VoidCallback? onSos;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.joshuaRHughes,
                style: context.headlineSmallStyle?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  height: 36 / 24,
                  color: AppColors.primaryWhite,
                ),
              ),
              2.ph,
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.trackedTrackingActiveGreen.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  8.pw,
                  Text(
                    AppStrings.trackingActive,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: AppColors.trackedTrackingActiveGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        10.pw,
        _SosButton(onTap: onSos),
      ],
    );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60.w,
        height: 60.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trackedSosRed.withValues(alpha: 0.15),
                border: Border.all(
                  color: AppColors.trackedSosRed.withValues(alpha: 0.3),
                  width: 1.44,
                ),
              ),
              child: Text(
                AppStrings.sos,
                style: context.bodyLargeStyle?.copyWith(
                  fontSize: 16.37.sp,
                  fontWeight: FontWeight.w700,
                  height: 21.82 / 16.37,
                  color: AppColors.trackedSosRed,
                ),
              ),
            ),
            SvgPicture.asset(
              AppAssetsSvg.trackedHomeSosRing,
              width: 60.w,
              height: 60.w,
            ),
          ],
        ),
      ),
    );
  }
}
