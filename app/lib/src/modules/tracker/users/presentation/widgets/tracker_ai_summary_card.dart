import '../../../../../core/utils/app_exports.dart';
import 'tracker_detail_text.dart';

/// The one card on the AI Insights screen: who the summary is for, the date
/// range it covers, and the button that asks for it.
class TrackerAiSummaryCard extends StatelessWidget {
  const TrackerAiSummaryCard({
    super.key,
    required this.initials,
    required this.name,
    required this.ranges,
    required this.selectedRange,
    required this.onRangeSelected,
    this.onGenerate,
  });

  final String initials;
  final String name;
  final List<String> ranges;
  final String selectedRange;
  final ValueChanged<String> onRangeSelected;
  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TrackerDetailText(
              AppStrings.trackerAiGenerateSummary,
              size: 16,
              weight: FontWeight.w600,
              height: 24 / 16,
            ),
            10.ph,
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: AppInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.trackerSurfaceFill,
                  borderRadius: 20.circular,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.trackerBorderSoft,
                      ),
                      child: TrackerDetailText(initials,
                          size: 12,
                          weight: FontWeight.w600,
                          height: 16 / 12,
                          color: AppColors.primaryWhite),
                    ),
                    8.pw,
                    TrackerDetailText(name,
                        weight: FontWeight.w500, height: 20 / 14),
                  ],
                ),
              ),
            ),
            10.ph,
            Text(
              AppStrings.trackerAiDateRange,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 16 / 12,
                fontWeight: FontWeight.w500,
                letterSpacing: .3,
                color: AppColors.primaryWhite,
              ),
            ),
            10.ph,
            for (final range in ranges) ...[
              _TrackerAiRangeOption(
                label: range,
                selected: range == selectedRange,
                onTap: () => onRangeSelected(range),
              ),
              6.ph,
            ],
            GestureDetector(
              onTap: onGenerate,
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                padding: AppInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.trackerBorderSoft,
                  borderRadius: 20.circular,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppAssetsSvg.trackerAiSparkle,
                        width: 16.w, height: 16.w),
                    8.pw,
                    const TrackerDetailText(
                      AppStrings.trackerAiGenerateSummaryAction,
                      size: 16,
                      weight: FontWeight.w600,
                      height: 24 / 16,
                      color: AppColors.primaryWhite,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _TrackerAiRangeOption extends StatelessWidget {
  const _TrackerAiRangeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        selected: selected,
        inMutuallyExclusiveGroup: true,
        button: true,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.trackerPurpleDeep
                  : AppColors.trackerSurfaceFill,
              borderRadius: 20.circular,
              border: Border.all(
                color: selected
                    ? AppColors.trackerBorderSoft
                    : AppColors.trackerSurfaceFill,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 16.w,
                  height: 16.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryWhite),
                  ),
                  child: selected
                      ? Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryWhite,
                          ),
                        )
                      : null,
                ),
                12.pw,
                Expanded(
                  child: TrackerDetailText(
                    label,
                    weight: FontWeight.w500,
                    height: 20 / 14,
                    color: selected
                        ? AppColors.viewerSignInText
                        : AppColors.primaryWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
