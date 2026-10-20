import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_case_entity.dart';

/// One case timeline entry: when it happened, who it concerns, where, and the
/// authenticity score the log carried.
class TrackerCaseEventCard extends StatelessWidget {
  const TrackerCaseEventCard({super.key, required this.event, this.onViewLog});

  final TrackerCaseEventEntity event;
  final VoidCallback? onViewLog;

  @override
  Widget build(BuildContext context) {
    final muted = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 1.2,
      color: AppColors.trackerMutedText,
    );

    return Container(
      padding: AppInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.trackerSurfaceFill,
        borderRadius: 20.circular,
        border: Border.all(color: AppColors.trackerSurfaceFill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(event.timestamp, style: muted)),
              8.pw,
              Container(
                padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: event.kind.fill,
                  borderRadius: 100.circular,
                ),
                child: Text(
                  event.kind.label,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    color: event.kind.color,
                  ),
                ),
              ),
            ],
          ),
          10.ph,
          Text(
            event.name,
            style: context.bodyMediumStyle?.copyWith(
              fontSize: 14.sp,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: AppColors.viewerSignInText,
            ),
          ),
          10.ph,
          Text(event.location, style: muted),
          10.ph,
          Row(
            children: [
              Expanded(
                child: Text(
                  '${AppStrings.trackerCaseAuthPrefix}${event.authScore}',
                  style: muted?.copyWith(color: event.authColor),
                ),
              ),
              8.pw,
              GestureDetector(
                onTap: onViewLog,
                child: Text(
                  AppStrings.trackerCaseViewLog,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.trackerInfoBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
