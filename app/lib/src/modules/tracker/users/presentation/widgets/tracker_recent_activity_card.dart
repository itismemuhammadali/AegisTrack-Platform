import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../domain/entities/tracker_activity_entity.dart';
import 'tracker_detail_surface.dart';
import 'tracker_detail_text.dart';

class TrackerRecentActivityCard extends StatelessWidget {
  const TrackerRecentActivityCard({
    super.key,
    required this.activity,
    this.onEntrySelected,
  });

  final List<TrackerActivityEntity> activity;
  final ValueChanged<TrackerActivityEntity>? onEntrySelected;

  @override
  Widget build(BuildContext context) => TrackerDetailSurface(
        padding: 0,
        child: Column(
          children: [
            for (var i = 0; i < activity.length; i++) ...[
              if (i > 0)
                const Divider(height: 1, color: AppColors.trackerSurfaceFill),
              _TrackerActivityRow(
                entry: activity[i],
                onTap: onEntrySelected == null
                    ? null
                    : () => onEntrySelected!(activity[i]),
              ),
            ],
          ],
        ),
      );
}

class _TrackerActivityRow extends StatelessWidget {
  const _TrackerActivityRow({required this.entry, this.onTap});

  final TrackerActivityEntity entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: AppInsets.all(16),
          child: Row(
            children: [
              TrackerDetailText(entry.time,
                  size: 12, color: AppColors.trackerMutedText),
              14.pw,
              TrackerBadge(entry.label, color: entry.color),
              14.pw,
              SvgPicture.asset(AppAssetsSvg.trackerUserDetailLocation,
                  width: 12.w, height: 12.w),
              6.pw,
              Expanded(
                child: TrackerDetailText(entry.location,
                    size: 12, color: AppColors.trackerMutedText),
              ),
              8.pw,
              SvgPicture.asset(AppAssetsSvg.trackerUserDetailChevron,
                  width: 16.w, height: 16.w),
            ],
          ),
        ),
      );
}
