import '../../../../../core/utils/app_exports.dart';
import '../../../home/presentation/widgets/tracked_face_frame.dart';
import '../controller/tracked_settings_controller.dart';
import '../widgets/tracked_anti_spoof_check_row.dart';

class TrackedAntiSpoofingView extends HookConsumerWidget {
  const TrackedAntiSpoofingView({super.key, this.onInfo});

  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedSettingsControllerProvider);

    // Start the timed scan on open; stop it when the screen closes.
    useEffect(() {
      Future.microtask(controller.startAntiSpoofing);
      return controller.stopAntiSpoofing;
    }, const []);

    return Scaffold(
      backgroundColor: AppColors.trackedLogCaptureHeaderBackdrop,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.5, 1],
            colors: [
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _Header(onInfo: onInfo),
              24.ph,
              Expanded(
                child: switch (controller.antiSpoofPhase) {
                  TrackedAntiSpoofPhase.scanning =>
                    _ScanningPhase(controller: controller),
                  TrackedAntiSpoofPhase.analyzing =>
                    _AnalyzingPhase(controller: controller),
                  TrackedAntiSpoofPhase.result =>
                    _ResultPhase(controller: controller),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.onInfo});

  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.only(left: 24, right: 24, top: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: AppRouterGo.back,
            child: Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryWhite.withValues(alpha: 0.1),
                borderRadius: 18.circular,
                border: Border.all(
                  color: AppColors.primaryWhite.withValues(alpha: 0.2),
                ),
              ),
              child: SvgPicture.asset(
                AppAssetsSvg.trackedLiveMapBack,
                width: 20.w,
                height: 20.w,
              ),
            ),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.trackedSettingsAntiSpoofing,
                  style: context.titleLargeStyle?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    height: 28 / 20,
                    color: AppColors.primaryWhite,
                  ),
                ),
                Text(
                  AppStrings.antiSpoofSubtitle,
                  style: context.bodyMediumStyle?.copyWith(
                    fontSize: 14.sp,
                    height: 20 / 14,
                    color: AppColors.signInDarkSubtitle,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onInfo,
            child: Container(
              width: 32.w,
              height: 32.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryWhite.withValues(alpha: 0.05),
                borderRadius: 14.circular,
                border: Border.all(
                  color: AppColors.primaryWhite.withValues(alpha: 0.1),
                ),
              ),
              child: SvgPicture.asset(
                AppAssetsSvg.trackedAntiSpoofInfo,
                width: 16.w,
                height: 16.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanningPhase extends StatelessWidget {
  const _ScanningPhase({required this.controller});

  final TrackedSettingsController controller;

  static const _sensors = [
    (AppStrings.antiSpoofDepthSensor, 0.98),
    (AppStrings.antiSpoofIrCamera, 0.86),
    (AppStrings.antiSpoofMotionDetect, 0.5),
    (AppStrings.antiSpoofTextureMap, 0.79),
  ];

  @override
  Widget build(BuildContext context) {
    final percent = (controller.antiSpoofScanProgress * 100).round();

    return Padding(
      padding: AppInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(
        children: [
          const Expanded(
            child: TrackedFaceFrame(
              topBadge: _ScanningPill(),
              hint: AppStrings.selfiePositionFace,
            ),
          ),
          24.ph,
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                for (final (label, dotOpacity) in _sensors)
                  _SensorChip(label: label, dotOpacity: dotOpacity),
              ],
            ),
          ),
          24.ph,
          _StatusBar(
            label: '${AppStrings.antiSpoofScanningPrefix}$percent%)',
          ),
        ],
      ),
    );
  }
}

class _AnalyzingPhase extends StatelessWidget {
  const _AnalyzingPhase({required this.controller});

  final TrackedSettingsController controller;

  @override
  Widget build(BuildContext context) {
    final checks = controller.antiSpoofChecks;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: AppInsets.symmetric(horizontal: 24),
            children: [
              const _RunningAnalysisCard(),
              24.ph,
              for (var i = 0; i < checks.length; i++) ...[
                if (i > 0) 10.ph,
                TrackedAntiSpoofCheckRow(
                  check: checks[i],
                  state: i < controller.antiSpoofChecksDone
                      ? TrackedAntiSpoofCheckState.passed
                      : i == controller.antiSpoofChecksDone
                          ? TrackedAntiSpoofCheckState.active
                          : TrackedAntiSpoofCheckState.pending,
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: AppInsets.all(24),
          child: const _StatusBar(label: AppStrings.antiSpoofAnalyzingChecks),
        ),
      ],
    );
  }
}

class _ResultPhase extends StatelessWidget {
  const _ResultPhase({required this.controller});

  final TrackedSettingsController controller;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.trackedZoneAllowedGreen;
    final captionStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 16 / 12,
    );

    return ListView(
      padding: AppInsets.only(left: 24, right: 24, bottom: 24),
      children: [
        Container(
          padding: AppInsets.all(20),
          decoration: BoxDecoration(
            color: green.withValues(alpha: 0.1),
            borderRadius: 16.circular,
            border: Border.all(color: green.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.13),
                  borderRadius: 16.circular,
                ),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedAntiSpoofAuthentic,
                  width: 28.w,
                  height: 28.w,
                ),
              ),
              16.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.antiSpoofAuthentic,
                      style: context.titleMediumStyle?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        height: 28 / 18,
                        letterSpacing: 0.45,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                    4.ph,
                    Text(
                      AppStrings.antiSpoofAuthenticSubtitle,
                      style: captionStyle?.copyWith(
                        height: 19.5 / 12,
                        color: AppColors.signInDarkSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        24.ph,
        Container(
          padding: AppInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite.withValues(alpha: 0.04),
            borderRadius: 16.circular,
            border: Border.all(
              color: AppColors.primaryWhite.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.antiSpoofScore.toUpperCase(),
                          style: captionStyle?.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                            color: AppColors.hintGray,
                          ),
                        ),
                        4.ph,
                        Text(
                          AppStrings.antiSpoofScoreSubtitle,
                          style: captionStyle?.copyWith(
                            color: AppColors.signInDarkSubtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ScoreRing(score: controller.antiSpoofScore),
                ],
              ),
              for (final check in controller.antiSpoofChecks) ...[
                10.ph,
                _ScoreBar(label: check.title, score: check.score),
              ],
            ],
          ),
        ),
        24.ph,
        Text(
          AppStrings.antiSpoofCheckResults.toUpperCase(),
          style: captionStyle?.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            color: AppColors.hintGray,
          ),
        ),
        for (final check in controller.antiSpoofChecks) ...[
          10.ph,
          TrackedAntiSpoofCheckRow(
            check: check,
            state: TrackedAntiSpoofCheckState.passed,
          ),
        ],
      ],
    );
  }
}

class _ScanningPill extends StatelessWidget {
  const _ScanningPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryblack.withValues(alpha: 0.6),
        borderRadius: 100.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.trackedZoneAllowedGreen.withValues(alpha: 0.44),
            ),
          ),
          8.pw,
          Text(
            AppStrings.antiSpoofScanningFace,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
              color: AppColors.primaryWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class _SensorChip extends StatelessWidget {
  const _SensorChip({required this.label, required this.dotOpacity});

  final String label;
  final double dotOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 18.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.trackedZoneAllowedGreen
                  .withValues(alpha: dotOpacity),
            ),
          ),
          6.pw,
          Text(
            label,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              height: 16 / 12,
              color: AppColors.signInDarkSubtitle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Glass bar with a spinner — "Scanning (x%)" / "Analyzing security checks…".
class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryWhite.withValues(alpha: 0.8),
              backgroundColor: AppColors.primaryWhite.withValues(alpha: 0.2),
            ),
          ),
          8.pw,
          Text(
            label,
            style: context.bodyMediumStyle?.copyWith(
              fontSize: 14.sp,
              height: 20 / 14,
              color: AppColors.primaryWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class _RunningAnalysisCard extends HookWidget {
  const _RunningAnalysisCard();

  @override
  Widget build(BuildContext context) {
    final spin = useAnimationController(duration: const Duration(seconds: 2));
    useEffect(() {
      spin.repeat();
      return null;
    }, [spin]);

    return Container(
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.twoFactorAccentPurple.withValues(alpha: 0.1),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.twoFactorAccentPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          RotationTransition(
            turns: spin,
            child: SvgPicture.asset(
              AppAssetsSvg.trackedAntiSpoofAnalysis,
              width: 32.w,
              height: 32.w,
            ),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.antiSpoofRunning,
                  style: context.bodyMediumStyle?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 20 / 14,
                    color: AppColors.primaryWhite,
                  ),
                ),
                2.ph,
                Text(
                  AppStrings.antiSpoofRunningSubtitle,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    color: AppColors.signInDarkSubtitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 100.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 8,
              color: AppColors.trackedZoneAllowedGreen,
              backgroundColor: AppColors.primaryWhite.withValues(alpha: 0.06),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: context.headlineMediumStyle?.copyWith(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                  height: 36 / 30,
                  color: AppColors.primaryWhite,
                ),
              ),
              2.ph,
              Text(
                AppStrings.antiSpoofScoreMax,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: AppColors.hintGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    final style = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 16 / 12,
    );

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: style?.copyWith(color: AppColors.signInDarkSubtitle),
              ),
            ),
            Text(
              '$score%',
              style: style?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.trackedZoneAllowedGreen,
              ),
            ),
          ],
        ),
        4.ph,
        ClipRRect(
          borderRadius: 100.circular,
          child: Container(
            height: 6.h,
            color: AppColors.primaryWhite.withValues(alpha: 0.06),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: score / 100,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.trackedZoneAllowedGreen,
                  borderRadius: 100.circular,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
