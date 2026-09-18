import '../../../../../core/utils/app_exports.dart';

/// 108px SOS button that fills a red progress ring while pressed and fires
/// [onActivated] once held for [holdDuration]. Releasing early resets it.
class TrackedSosHoldButton extends HookWidget {
  const TrackedSosHoldButton({
    super.key,
    required this.onActivated,
    this.holdDuration = const Duration(seconds: 3),
  });

  final VoidCallback onActivated;
  final Duration holdDuration;

  @override
  Widget build(BuildContext context) {
    final progress = useAnimationController(duration: holdDuration);
    useAnimation(progress);

    useEffect(() {
      void listener(AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          HapticFeedback.heavyImpact();
          progress.reset();
          onActivated();
        }
      }

      progress.addStatusListener(listener);
      return () => progress.removeStatusListener(listener);
    }, [progress]);

    void release() {
      if (progress.status != AnimationStatus.completed) progress.reverse();
    }

    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.mediumImpact();
        progress.forward();
      },
      onTapUp: (_) => release(),
      onTapCancel: release,
      child: SizedBox(
        width: 108.w,
        height: 108.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trackedSosRed.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppColors.trackedSosRed.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.sos,
                    style: context.headlineSmallStyle?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      height: 32 / 24,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  Text(
                    AppStrings.sosHold,
                    style: context.labelSmallStyle?.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      height: 15 / 10,
                      color: AppColors.primaryWhite.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            IgnorePointer(
              child: SvgPicture.asset(
                AppAssetsSvg.trackedSosRing,
                width: 108.w,
                height: 108.w,
              ),
            ),
            // Progress drawn on the Figma ring track (88px, 4px stroke).
            IgnorePointer(
              child: SizedBox(
                width: 88.w,
                height: 88.w,
                child: CircularProgressIndicator(
                  value: progress.value,
                  strokeWidth: 4,
                  color: AppColors.trackedSosRed,
                  backgroundColor: AppColors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
