import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_zone_event_entity.dart';

class TrackedZoneEventCard extends StatelessWidget {
  const TrackedZoneEventCard({super.key, required this.event});

  final TrackedZoneEventEntity event;

  @override
  Widget build(BuildContext context) {
    final captionStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 16 / 12,
      color: AppColors.hintGray,
    );

    return Container(
      width: double.infinity,
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            margin: AppInsets.only(top: 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: event.color.withValues(alpha: 0.08),
              borderRadius: 18.circular,
            ),
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: event.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: context.bodyMediumStyle?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 20 / 14,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ),
                    Text(event.time, style: captionStyle),
                  ],
                ),
                2.ph,
                Text(
                  event.zone,
                  style: captionStyle?.copyWith(
                    color: AppColors.signInDarkSubtitle,
                  ),
                ),
                6.ph,
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssetsSvg.trackedZonePin,
                      width: 12.w,
                      height: 12.w,
                    ),
                    4.pw,
                    Flexible(
                      child: Text(
                        event.coordinates,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: captionStyle?.copyWith(fontFamily: 'monospace'),
                      ),
                    ),
                    12.pw,
                    SvgPicture.asset(
                      AppAssetsSvg.trackedZoneLogged,
                      width: 12.w,
                      height: 12.w,
                    ),
                    4.pw,
                    Text(
                      AppStrings.zoneStatusLogged,
                      style: captionStyle?.copyWith(
                        color: AppColors.trackedZoneAllowedGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
