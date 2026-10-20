import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_live_status_entity.dart';

class TrackerLivePingsCard extends StatelessWidget {
  const TrackerLivePingsCard({super.key, required this.pings});

  final List<TrackerLivePingEntity> pings;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.trackerRecentPings,
              style: context.bodyMediumStyle?.copyWith(
                fontSize: 14.sp,
                height: 20 / 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -.15,
                color: AppColors.viewerSignInText,
              ),
            ),
            12.ph,
            for (var i = 0; i < pings.length; i++) ...[
              if (i > 0) 8.ph,
              Container(
                padding: AppInsets.symmetric(vertical: 6),
                decoration: i == pings.length - 1
                    ? null
                    : const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: AppColors.trackerBorderSoft),
                        ),
                      ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                      child: Text(
                        pings[i].time,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          height: 16 / 12,
                          fontFamily: 'monospace',
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ),
                    12.pw,
                    Expanded(
                      child: Text(
                        pings[i].location,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          height: 16 / 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.viewerSignInText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
}
