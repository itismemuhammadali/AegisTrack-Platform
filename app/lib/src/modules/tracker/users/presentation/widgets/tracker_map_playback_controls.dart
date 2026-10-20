import '../../../../../core/utils/app_exports.dart';

class TrackerMapPlaybackControls extends StatelessWidget {
  const TrackerMapPlaybackControls({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.currentTime,
    required this.progress,
    required this.speeds,
    required this.speed,
    required this.onSpeedSelected,
    this.onRewind,
    this.onPlay,
    this.onForward,
  });

  final String startTime;
  final String endTime;
  final String currentTime;
  final double progress;
  final List<String> speeds;
  final String speed;
  final ValueChanged<String> onSpeedSelected;
  final VoidCallback? onRewind;
  final VoidCallback? onPlay;
  final VoidCallback? onForward;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: 100.circular,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.h,
                backgroundColor: AppColors.trackerBorderSoft,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.trackerPurpleDeep),
              ),
            ),
            4.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TrackerPlaybackTime(startTime),
                _TrackerPlaybackTime(endTime),
              ],
            ),
            12.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _TrackerPlaybackButton(
                      icon: AppAssetsSvg.trackerMapPlaybackPrev,
                      tooltip: AppStrings.trackerPlaybackRewind,
                      onTap: onRewind,
                    ),
                    16.pw,
                    _TrackerPlaybackButton(
                      icon: AppAssetsSvg.trackerMapPlaybackPlay,
                      tooltip: AppStrings.trackerPlaybackPlay,
                      filled: true,
                      onTap: onPlay,
                    ),
                    16.pw,
                    _TrackerPlaybackButton(
                      icon: AppAssetsSvg.trackerMapPlaybackNext,
                      tooltip: AppStrings.trackerPlaybackForward,
                      onTap: onForward,
                    ),
                  ],
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      currentTime,
                      style: context.titleMediumStyle?.copyWith(
                        fontSize: 18.sp,
                        height: 28 / 18,
                        fontFamily: 'monospace',
                        color: AppColors.viewerSignInText,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: AppInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.trackerBorderSoft,
                    borderRadius: 16.circular,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final option in speeds) ...[
                        if (option != speeds.first) 2.pw,
                        GestureDetector(
                          onTap: () => onSpeedSelected(option),
                          child: Container(
                            padding: AppInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: option == speed
                                  ? AppColors.trackerPurpleDeep
                                  : null,
                              borderRadius: 14.circular,
                            ),
                            child: Text(
                              option,
                              style: context.bodySmallStyle?.copyWith(
                                fontSize: 12.sp,
                                height: 16 / 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryWhite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _TrackerPlaybackTime extends StatelessWidget {
  const _TrackerPlaybackTime(this.time);

  final String time;

  @override
  Widget build(BuildContext context) => Text(
        time,
        style: context.bodySmallStyle?.copyWith(
          fontSize: 12.sp,
          height: 16 / 12,
          fontFamily: 'monospace',
          color: AppColors.primaryWhite,
        ),
      );
}

class _TrackerPlaybackButton extends StatelessWidget {
  const _TrackerPlaybackButton({
    required this.icon,
    required this.tooltip,
    this.filled = false,
    this.onTap,
  });

  final String icon;
  final String tooltip;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: filled ? 40.w : 20.w,
            height: filled ? 40.w : 20.w,
            alignment: Alignment.center,
            decoration: filled
                ? BoxDecoration(
                    color: AppColors.trackerPurpleDeep,
                    borderRadius: 20.circular,
                  )
                : null,
            child: SvgPicture.asset(icon, width: 20.w, height: 20.w),
          ),
        ),
      );
}
