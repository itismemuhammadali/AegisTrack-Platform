import '../../../../../core/utils/app_exports.dart';
import 'tracked_log_details_section.dart';

class TrackedLogDetailsLocationCard extends StatelessWidget {
  const TrackedLogDetailsLocationCard({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return TrackedLogDetailsGlassCard(
      padding: AppInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const _RoundIcon(
                  asset: AppAssetsSvg.trackedLogDetailsLocation, size: 40),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location,
                        style: context.titleMediumStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600)),
                    2.ph,
                    Text(AppStrings.trackedLogDetailsCoordinates,
                        style: TextStyle(
                            fontFamily: 'Consolas',
                            color: AppColors.trackedLogDetailsMutedText,
                            fontSize: 14.sp,
                            height: 20 / 14)),
                  ],
                ),
              ),
              const _RoundIcon(
                  asset: AppAssetsSvg.trackedLogDetailsVerified, size: 32),
            ],
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
  const _RoundIcon({required this.asset, required this.size});
  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size.w,
        height: size.w,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: AppColors.trackedLogDetailsIconBackground,
            shape: BoxShape.circle),
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
                      fontSize: (small ? 12 : 14).sp))),
        ],
      );
}
