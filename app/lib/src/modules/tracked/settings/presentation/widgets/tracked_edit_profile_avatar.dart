import '../../../../../core/utils/app_exports.dart';

class TrackedEditProfileAvatar extends StatelessWidget {
  const TrackedEditProfileAvatar({super.key, required this.onTap, this.photo});

  final VoidCallback onTap;
  final File? photo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 112.w,
        height: 112.w,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onboardingPurpleGradientStart
                        .withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: Offset(0, 10.h),
                  ),
                  BoxShadow(
                    color: AppColors.onboardingPurpleGradientStart
                        .withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: ClipOval(
                child: photo != null
                    ? Image.file(
                        photo!,
                        width: 112.w,
                        height: 112.w,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        AppAssetsPng.trackedSettingsProfileAvatar,
                        width: 112.w,
                        height: 112.w,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryWhite.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppColors.primaryWhite.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 20.sp,
                    color: AppColors.primaryWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
