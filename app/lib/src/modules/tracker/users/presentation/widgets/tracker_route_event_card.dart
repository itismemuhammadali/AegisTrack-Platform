import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_route_event_entity.dart';

class TrackerRouteEventCard extends StatelessWidget {
  const TrackerRouteEventCard({super.key, required this.event, this.onViewLog});

  final TrackerRouteEventEntity event;
  final VoidCallback? onViewLog;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(
              color: event.kind.borderColor ?? AppColors.trackerBorderSoft),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppInsets.only(top: 2),
              child: event.kind.icon != null
                  ? SvgPicture.asset(event.kind.icon!,
                      width: 16.w, height: 16.w)
                  : Container(
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: event.kind.color,
                      ),
                    ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 17.5 / 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -.15,
                      color: AppColors.viewerSignInText,
                    ),
                  ),
                  2.ph,
                  Text(
                    event.subtitle,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  if (event.note != null) ...[
                    2.ph,
                    Text(
                      event.note!,
                      style: context.bodySmallStyle?.copyWith(
                        fontSize: 12.sp,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.trackerAmber,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            8.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  event.time,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    fontFamily: 'monospace',
                    color: AppColors.primaryWhite,
                  ),
                ),
                4.ph,
                GestureDetector(
                  onTap: onViewLog,
                  child: Text(
                    AppStrings.trackerViewLog,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.trackerFlaggedRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
