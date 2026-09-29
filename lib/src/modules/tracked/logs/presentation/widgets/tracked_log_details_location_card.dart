import '../../../../../core/utils/app_exports.dart';
import 'tracked_log_details_section.dart';

class TrackedLogDetailsLocationCard extends StatelessWidget {
  const TrackedLogDetailsLocationCard({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return TrackedLogDetailsGlassCard(
      padding: AppInsets.all(21.085),
      borderWidth: 1.085.w,
      child: Column(
        children: [
          SizedBox(
            height: 52.w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  right: 66.24.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _RoundIcon(
                        asset: AppAssetsSvg.trackedLogDetailsLocation,
                        size: 40,
                      ),
                      12.pw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.titleMediumStyle?.copyWith(
                                color: AppColors.primaryWhite,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                height: 28 / 18,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  AppStrings.trackedLogDetailsCoordinates,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    color: AppColors.trackedLogDetailsMutedText,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0,
                                    height: 20 / 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -5.w,
                  right: -3.w,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryWhite.withValues(alpha: 0.1),
                      borderRadius: 14.circular,
                    ),
                    child: SvgPicture.asset(
                      AppAssetsSvg.trackedLogDetailsVerified,
                      width: 16.w,
                      height: 16.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          16.ph,
          const _IconText(AppAssetsSvg.trackedLogDetailsCalendar,
              AppStrings.trackedLogDetailsTimestamp),
          12.ph,
          const _IconText(AppAssetsSvg.trackedLogDetailsLock,
              AppStrings.trackedLogDetailsLocked,
              small: true),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.asset,
    required this.size,
  });

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size.w,
        height: size.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child:
            SvgPicture.asset(asset, width: (size / 2).w, height: (size / 2).w),
      );
}

class _IconText extends StatelessWidget {
  const _IconText(this.asset, this.text, {this.small = false});
  final String asset;
  final String text;
  final bool small;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SvgPicture.asset(asset,
              width: (small ? 12 : 16).w, height: (small ? 12 : 16).w),
          (small ? 4 : 8).pw,
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      color: small
                          ? AppColors.trackedLogTagText
                          : AppColors.trackedLogDetailsMutedText,
                      fontSize: (small ? 12 : 14).sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      height: small ? 16 / 12 : 20 / 14))),
        ],
      );
}
