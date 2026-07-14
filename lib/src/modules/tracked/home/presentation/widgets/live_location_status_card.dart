import 'dart:ui';

import '../../../../../core/utils/app_exports.dart';

class LiveLocationStatusCard extends StatelessWidget {
  const LiveLocationStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      width: double.infinity,
      padding: AppInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 24.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -60.w,
            top: -60.h,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
              child: Container(
                width: 128.w,
                height: 128.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onboardingPurpleGradientStart.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppAssetsSvg.trackedHomeLocationStatusIcon,
                    width: 20.sp,
                    height: 20.sp,
                  ),
                  8.pw,
                  Text(
                    AppStrings.liveLocationStatus,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryWhite.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              10.ph,
              Text(
                AppStrings.locationLogged,
                style: context.headlineSmallStyle?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryWhite,
                ),
              ),
              10.ph,
              Text(
                AppStrings.lastUpdated,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.signInDarkSubtitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
