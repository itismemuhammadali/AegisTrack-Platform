import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_live_status_entity.dart';

class TrackerLiveStatsRow extends StatelessWidget {
  const TrackerLiveStatsRow({super.key, required this.stats});

  final List<TrackerLiveStatEntity> stats;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0) 16.pw,
              Expanded(child: _TrackerLiveStatCard(stat: stats[i])),
            ],
          ],
        ),
      );
}

class _TrackerLiveStatCard extends StatelessWidget {
  const _TrackerLiveStatCard({required this.stat});

  final TrackerLiveStatEntity stat;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.trackerOnlineGreen,
                  ),
                ),
                6.pw,
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      stat.label.toUpperCase(),
                      style: context.bodySmallStyle?.copyWith(
                        fontSize: 12.sp,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .3,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            4.ph,
            Text(
              stat.value,
              style: context.bodyMediumStyle?.copyWith(
                fontSize: 14.sp,
                height: 20 / 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -.15,
                color: AppColors.viewerSignInText,
              ),
            ),
            4.ph,
            Text(
              stat.subtitle,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 16 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      );
}
