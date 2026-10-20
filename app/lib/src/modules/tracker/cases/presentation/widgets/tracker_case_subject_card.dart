import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_case_entity.dart';

/// A monitored subject on the case, with their latest authenticity score.
class TrackerCaseSubjectCard extends StatelessWidget {
  const TrackerCaseSubjectCard({super.key, required this.subject});

  final TrackerCaseSubjectEntity subject;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trackerPurpleDeep,
              ),
              child: Text(
                subject.initials,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  height: 20 / 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.viewerSignInText,
                ),
              ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.viewerSignInText,
                    ),
                  ),
                  4.ph,
                  Text(
                    subject.role,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 1.2,
                      color: AppColors.trackerMutedText,
                    ),
                  ),
                ],
              ),
            ),
            12.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  subject.score,
                  style: context.titleMediumStyle?.copyWith(
                    fontSize: 18.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: subject.scoreColor,
                  ),
                ),
                Text(
                  AppStrings.trackerCaseAuthScore,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 1.2,
                    color: AppColors.trackerMutedText,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
