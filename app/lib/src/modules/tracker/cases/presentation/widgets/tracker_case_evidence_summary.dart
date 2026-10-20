import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../domain/entities/tracker_case_entity.dart';

/// Evidence summary: the counts behind the case, three tiles to a row.
class TrackerCaseEvidenceSummary extends StatelessWidget {
  const TrackerCaseEvidenceSummary({super.key, required this.stats});

  final List<TrackerCaseEvidenceStatEntity> stats;

  @override
  Widget build(BuildContext context) => TrackerSurface(
        padding: 0,
        borderColor: AppColors.trackerSurfaceFill,
        child: Padding(
          padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.trackerCaseEvidenceSummary,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.trackerMutedText,
                ),
              ),
              14.ph,
              for (var i = 0; i < stats.length; i += 3) ...[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var j = i; j < i + 3; j++) ...[
                        Expanded(
                          child: j < stats.length
                              ? _TrackerCaseEvidenceTile(stat: stats[j])
                              : const SizedBox.shrink(),
                        ),
                        if (j < i + 2) 10.pw,
                      ],
                    ],
                  ),
                ),
                if (i + 3 < stats.length) 10.ph,
              ],
            ],
          ),
        ),
      );
}

class _TrackerCaseEvidenceTile extends StatelessWidget {
  const _TrackerCaseEvidenceTile({required this.stat});

  final TrackerCaseEvidenceStatEntity stat;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
        ),
        child: Column(
          children: [
            SvgPicture.asset(stat.icon, width: 16.w, height: 16.w),
            4.ph,
            Text(
              stat.value,
              style: context.titleMediumStyle?.copyWith(
                fontSize: 18.sp,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.viewerSignInText,
              ),
            ),
            4.ph,
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                stat.label,
                textAlign: TextAlign.center,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 1.2,
                  color: AppColors.trackerMutedText,
                ),
              ),
            ),
          ],
        ),
      );
}
