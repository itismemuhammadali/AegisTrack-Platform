import '../../../../../core/utils/app_exports.dart';
import 'tracker_detail_text.dart';
import 'tracker_log_section_card.dart';

/// Placeholder for the log's photo evidence. The design shows the empty frame
/// rather than a thumbnail, so the attachment is represented by its caption.
class TrackerLogMediaCard extends StatelessWidget {
  const TrackerLogMediaCard({super.key, required this.caption});

  final String caption;

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
            const TrackerLogSectionTitle(AppStrings.trackerLogMediaSection),
            10.ph,
            Container(
              width: double.infinity,
              height: 128.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.trackerSurfaceFill,
                borderRadius: 20.circular,
              ),
              child: SvgPicture.asset(AppAssetsSvg.trackerLogImage,
                  width: 32.w, height: 32.w),
            ),
            10.ph,
            SizedBox(
              width: double.infinity,
              child: Text(
                caption,
                textAlign: TextAlign.center,
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

/// The two outline buttons closing the log record.
class TrackerLogFooterButton extends StatelessWidget {
  const TrackerLogFooterButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          padding: AppInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.trackerSurfaceFill,
            borderRadius: 16.circular,
            border: Border.all(color: AppColors.trackerBorderSoft),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon, width: 16.w, height: 16.w),
              8.pw,
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TrackerDetailText(label,
                      weight: FontWeight.w500,
                      height: 20 / 14,
                      color: AppColors.primaryWhite),
                ),
              ),
            ],
          ),
        ),
      );
}
