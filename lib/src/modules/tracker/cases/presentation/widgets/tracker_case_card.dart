import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../domain/entities/tracker_case_entity.dart';

class TrackerCaseCard extends StatelessWidget {
  const TrackerCaseCard({super.key, required this.caseEntity, this.onTap});

  final TrackerCaseEntity caseEntity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: TrackerSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          caseEntity.id,
                          style: context.bodySmallStyle?.copyWith(
                            fontSize: 11.sp,
                            fontFamily: 'monospace',
                            color: AppColors.primaryWhite,
                          ),
                        ),
                        TrackerBadge(caseEntity.status,
                            color: caseEntity.statusColor),
                        if (caseEntity.legalHold)
                          const TrackerBadge(AppStrings.trackerLegalHold,
                              color: AppColors.trackerAmber,
                              background: AppColors.trackerLegalHoldSurface),
                      ],
                    ),
                  ),
                  8.pw,
                  SvgPicture.asset(
                    AppAssetsSvg.trackerAlertChevron,
                    width: 16.w,
                    height: 16.w,
                    colorFilter: const ColorFilter.mode(
                        AppColors.primaryWhite, BlendMode.srcIn),
                  ),
                ],
              ),
              10.ph,
              Text(
                caseEntity.title,
                style: context.titleMediumStyle?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.viewerSignInText,
                ),
              ),
              12.ph,
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: [
                  for (final person in caseEntity.people)
                    _TrackerCasePersonChip(person: person),
                ],
              ),
              12.ph,
              Text(
                '${caseEntity.evidence}    ·    ${caseEntity.date}',
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryWhite,
                ),
              ),
            ],
          ),
        ),
      );
}

class _TrackerCasePersonChip extends StatelessWidget {
  const _TrackerCasePersonChip({required this.person});

  final TrackerCasePersonEntity person;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.trackerBorderSoft,
          borderRadius: 100.circular,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trackerAvatarPurple,
              ),
              child: Text(
                person.initials,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
            4.pw,
            Text(
              person.name,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                color: AppColors.primaryWhite,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
}
