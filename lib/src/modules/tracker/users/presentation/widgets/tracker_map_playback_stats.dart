import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_detail_info_entity.dart';

class TrackerMapPlaybackStats extends StatelessWidget {
  const TrackerMapPlaybackStats({super.key, required this.stats});

  final List<TrackerDetailInfoEntity> stats;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0) 8.pw,
              Expanded(child: _TrackerPlaybackStatTile(stat: stats[i])),
            ],
          ],
        ),
      );
}

class _TrackerPlaybackStatTile extends StatelessWidget {
  const _TrackerPlaybackStatTile({required this.stat});

  final TrackerDetailInfoEntity stat;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                stat.value,
                style: context.titleMediumStyle?.copyWith(
                  fontSize: 16.sp,
                  height: 24 / 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -.31,
                  color: AppColors.viewerSignInText,
                ),
              ),
            ),
            2.ph,
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                stat.label,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
          ],
        ),
      );
}
