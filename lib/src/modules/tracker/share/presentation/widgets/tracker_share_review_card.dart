import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_share_entity.dart';
import 'tracker_share_common.dart';

/// Step 3: everything the link will carry, before it is cut.
class TrackerShareReviewCard extends StatelessWidget {
  const TrackerShareReviewCard({super.key, required this.rows});

  final List<TrackerShareReviewEntity> rows;

  @override
  Widget build(BuildContext context) => TrackerShareCard(
        title: AppStrings.trackerShareReviewTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final row in rows)
              Container(
                padding: AppInsets.symmetric(vertical: 12),
                decoration: row == rows.last
                    ? null
                    : const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: AppColors.trackerSurfaceFill)),
                      ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppInsets.only(top: 2),
                      child:
                          SvgPicture.asset(row.icon, width: 16.w, height: 16.w),
                    ),
                    12.pw,
                    SizedBox(
                      width: 64.w,
                      child: TrackerDetailText(row.label,
                          size: 12,
                          height: 16 / 12,
                          color: AppColors.primaryWhite),
                    ),
                    12.pw,
                    Expanded(
                      child: TrackerDetailText(
                        row.value,
                        weight: FontWeight.w500,
                        height: 20 / 14,
                        color: row.valueColor ?? AppColors.viewerSignInText,
                      ),
                    ),
                  ],
                ),
              ),
            16.ph,
            Container(
              width: double.infinity,
              padding: AppInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.trackerSurfaceFill,
                borderRadius: 20.circular,
                border: Border.all(color: AppColors.trackerSurfaceFill),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: AppStrings.trackerShareRecipientsPrefix),
                    TextSpan(
                      text: AppStrings.trackerShareRecipientsBold,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(
                        text: AppStrings.trackerShareRecipientsSuffix),
                  ],
                ),
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
          ],
        ),
      );
}

/// Amber caution below the review card.
class TrackerShareTemporaryNotice extends StatelessWidget {
  const TrackerShareTemporaryNotice({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerShareWarningFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerLogBannerBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppInsets.only(top: 2),
              child: SvgPicture.asset(AppAssetsSvg.trackerShareWarning,
                  width: 20.w, height: 20.w),
            ),
            12.pw,
            const Expanded(
              child: TrackerDetailText(AppStrings.trackerShareTemporaryNotice,
                  height: 20 / 14, color: AppColors.trackerWarningText),
            ),
          ],
        ),
      );
}
