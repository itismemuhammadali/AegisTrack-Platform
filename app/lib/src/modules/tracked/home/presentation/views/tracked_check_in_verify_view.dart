import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/presentation/widgets/tracked_subscription_scaffold.dart';
import '../controller/tracked_home_controller.dart';
import '../widgets/tracked_arc_action_bar.dart';

class TrackedCheckInVerifyView extends ConsumerWidget {
  const TrackedCheckInVerifyView({super.key});

  static const _methods = [
    (
      TrackedVerificationMethod.faceId,
      AppStrings.checkInFaceId,
      AppStrings.checkInFaceIdSubtitle,
      AppAssetsSvg.trackedVerifyFace,
      AppAssetsSvg.trackedVerifyFaceActive,
    ),
    (
      TrackedVerificationMethod.touchId,
      AppStrings.checkInTouchId,
      AppStrings.checkInTouchIdSubtitle,
      AppAssetsSvg.trackedVerifyTouch,
      AppAssetsSvg.trackedVerifyTouchActive,
    ),
    (
      TrackedVerificationMethod.android,
      AppStrings.checkInAndroid,
      AppStrings.checkInAndroidSubtitle,
      AppAssetsSvg.trackedVerifyAndroid,
      AppAssetsSvg.trackedVerifyAndroid,
    ),
  ];

  /// Face ID → straight to Selfie Capture. Touch ID / Android biometric →
  /// verify on this screen, then show Check-in Complete.
  Future<void> _start(TrackedHomeController controller) async {
    if (controller.method == TrackedVerificationMethod.faceId) {
      AppRouterGo.push(trackedSelfieCaptureView);
      return;
    }
    await controller.startVerification();
    _complete(controller);
  }

  static void _complete([TrackedHomeController? controller]) {
    controller?.confirmCheckIn();
    AppRouterGo.push(trackedCheckInCompleteView);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedHomeControllerProvider);
    final isIdle =
        controller.verificationState == TrackedVerificationState.idle;

    return PopScope(
      // Leaving the flow before it completes starts it over next time.
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) controller.resetCheckIn();
      },
      child: TrackedSubscriptionScaffold(
        title: AppStrings.checkInDuesTitle,
        subtitle: AppStrings.checkInDuesSubtitle,
        subtitleColor: AppColors.primaryWhite.withValues(alpha: 0.6),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    AppInsets.only(left: 24, right: 24, top: 16, bottom: 24),
                children: [
                  const _ScheduledCard(),
                  24.ph,
                  Text(
                    AppStrings.checkInVerificationMethod.toUpperCase(),
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      letterSpacing: 0.3,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  for (final (method, title, subtitle, icon, activeIcon)
                      in _methods) ...[
                    10.ph,
                    _MethodRow(
                      title: title,
                      subtitle: subtitle,
                      icon: controller.method == method ? activeIcon : icon,
                      isSelected: controller.method == method,
                      onTap: () => controller.selectMethod(method),
                    ),
                  ],
                  if (!isIdle) ...[
                    24.ph,
                    _VerifyingIndicator(controller: controller),
                  ],
                ],
              ),
            ),
            TrackedArcActionBar(
              child: TrackedArcButton(
                label: isIdle
                    ? AppStrings.checkInStartCheckIn
                    : AppStrings.checkInContinue,
                onTap: switch (controller.verificationState) {
                  TrackedVerificationState.idle => () => _start(controller),
                  TrackedVerificationState.verifying => null,
                  TrackedVerificationState.verified => _complete,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduledCard extends StatelessWidget {
  const _ScheduledCard();

  @override
  Widget build(BuildContext context) {
    const amber = AppColors.trackedCheckInAmber;

    return Container(
      padding: AppInsets.all(20),
      decoration: BoxDecoration(
        color: amber.withValues(alpha: 0.1),
        borderRadius: 16.circular,
        border: Border.all(color: amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: amber.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedCheckInScheduled,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
              12.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.checkInScheduled,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 20 / 14,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  Text(
                    AppStrings.checkInScheduledFor,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      color: amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
          10.ph,
          Text(
            AppStrings.checkInDuesDescription,
            style: context.bodyMediumStyle?.copyWith(
              fontSize: 14.sp,
              height: 22.75 / 14,
              color: AppColors.signInDarkSubtitle,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  const _MethodRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(
            alpha: isSelected ? 0.1 : 0.05,
          ),
          borderRadius: 16.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(
              alpha: isSelected ? 0.3 : 0.1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.twoFactorAccentPurple.withValues(alpha: 0.5)
                    : AppColors.primaryWhite.withValues(alpha: 0.05),
                borderRadius: 18.circular,
              ),
              child: SvgPicture.asset(icon, width: 20.w, height: 20.w),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: isSelected
                          ? AppColors.primaryWhite
                          : AppColors.signInDarkSubtitle,
                    ),
                  ),
                  2.ph,
                  Text(
                    subtitle,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      color: AppColors.hintGray,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20.w,
              height: 20.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.twoFactorAccentPurple : null,
                border: Border.all(
                  color: isSelected
                      ? AppColors.twoFactorAccentPurple
                      : AppColors.primaryWhite.withValues(alpha: 0.3),
                ),
              ),
              child: isSelected
                  ? Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryWhite,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifyingIndicator extends StatelessWidget {
  const _VerifyingIndicator({required this.controller});

  final TrackedHomeController controller;

  String get _icon => switch (controller.method) {
        TrackedVerificationMethod.touchId =>
          AppAssetsSvg.trackedVerifyFingerprintLarge,
        TrackedVerificationMethod.faceId =>
          AppAssetsSvg.trackedVerifyFaceActive,
        TrackedVerificationMethod.android => AppAssetsSvg.trackedVerifyAndroid,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: 0.8,
          child: Container(
            width: 83.w,
            height: 83.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryWhite.withValues(alpha: 0.2),
              border: Border.all(
                color: AppColors.primaryWhite.withValues(alpha: 0.5),
              ),
            ),
            child: SvgPicture.asset(_icon, width: 41.w, height: 41.w),
          ),
        ),
        16.ph,
        Text(
          controller.isVerified
              ? AppStrings.checkInVerified
              : AppStrings.checkInVerifying,
          style: context.bodyMediumStyle?.copyWith(
            fontSize: 14.sp,
            height: 20 / 14,
            color: AppColors.primaryWhite,
          ),
        ),
      ],
    );
  }
}
