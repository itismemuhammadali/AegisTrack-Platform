import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_log_entry_entity.dart';
import 'tracked_log_status_badge.dart';
import 'tracked_log_tag_chip.dart';

class TrackedLogEntryCard extends StatelessWidget {
  const TrackedLogEntryCard({super.key, required this.entry, this.onTap});

  final TrackedLogEntryEntity entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
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
              width: 40.w,
              height: 40.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.onboardingButtonGradientColors,
                  stops: AppColors.onboardingButtonGradientStops,
                ),
              ),
              child: SvgPicture.asset(
                AppAssetsSvg.trackedLogsLocationPinIcon,
                width: 20.sp,
                height: 20.sp,
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
                          entry.location,
                          style: context.bodyMediumStyle?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ),
                      TrackedLogStatusBadge(status: entry.status),
                    ],
                  ),
                  6.ph,
                  Text(
                    entry.timestamp,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.signInDarkSubtitle,
                    ),
                  ),
                  if (entry.tags.isNotEmpty) ...[
                    6.ph,
                    Row(
                      children: [
                        for (final tag in entry.tags) ...[
                          TrackedLogTagChip(label: tag),
                          if (tag != entry.tags.last) 8.pw,
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
