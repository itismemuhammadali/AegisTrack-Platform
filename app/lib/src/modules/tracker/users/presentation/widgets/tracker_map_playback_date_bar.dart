import '../../../../../core/utils/app_exports.dart';

class TrackerMapPlaybackDateBar extends StatelessWidget {
  const TrackerMapPlaybackDateBar({
    super.key,
    required this.date,
    required this.range,
    required this.ranges,
    required this.onRangeSelected,
    this.onPreviousDay,
    this.onNextDay,
  });

  final String date;
  final String range;
  final List<String> ranges;
  final ValueChanged<String> onRangeSelected;
  final VoidCallback? onPreviousDay;
  final VoidCallback? onNextDay;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _TrackerDateStepButton(
            icon: AppAssetsSvg.trackerMapPlaybackDatePrev,
            tooltip: AppStrings.trackerPreviousDay,
            onTap: onPreviousDay,
          ),
          8.pw,
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                date,
                maxLines: 1,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  height: 20 / 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -.15,
                  color: AppColors.viewerSignInText,
                ),
              ),
            ),
          ),
          8.pw,
          _TrackerDateStepButton(
            icon: AppAssetsSvg.trackerTimelineChevron,
            tooltip: AppStrings.trackerNextDay,
            onTap: onNextDay,
          ),
          for (final option in ranges) ...[
            8.pw,
            Flexible(
              child: GestureDetector(
                onTap: () => onRangeSelected(option),
                child: Container(
                  padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: option == range
                        ? AppColors.trackerPurpleDeep
                        : AppColors.trackerSurfaceFill,
                    borderRadius: 16.circular,
                    border: Border.all(color: AppColors.trackerBorderSoft),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      option,
                      maxLines: 1,
                      style: context.bodySmallStyle?.copyWith(
                        fontSize: 12.sp,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
}

class _TrackerDateStepButton extends StatelessWidget {
  const _TrackerDateStepButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  final String icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.trackerSurfaceFill,
              borderRadius: 16.circular,
              border: Border.all(color: AppColors.trackerBorderSoft),
            ),
            child: SvgPicture.asset(icon, width: 16.w, height: 16.w),
          ),
        ),
      );
}
