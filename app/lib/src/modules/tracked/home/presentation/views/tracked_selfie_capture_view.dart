import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/presentation/widgets/tracked_subscription_scaffold.dart';
import '../controller/tracked_home_controller.dart';
import '../widgets/tracked_arc_action_bar.dart';
import '../widgets/tracked_face_frame.dart';

class TrackedSelfieCaptureView extends ConsumerWidget {
  const TrackedSelfieCaptureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedHomeControllerProvider);
    final selfie = controller.selfie;

    return TrackedSubscriptionScaffold(
      title: AppStrings.selfieTitle,
      subtitle: AppStrings.selfieSubtitle,
      subtitleColor: AppColors.primaryWhite.withValues(alpha: 0.6),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: AppInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: selfie == null ? 32 : 24,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: TrackedFaceFrame(
                      topBadge: const _GoodLightPill(),
                      hint: AppStrings.selfiePositionFace,
                      photo: selfie,
                    ),
                  ),
                  24.ph,
                  const _QualityChips(),
                  24.ph,
                  _ShutterButton(onTap: controller.captureSelfie),
                ],
              ),
            ),
          ),
          if (selfie != null)
            TrackedArcActionBar(
              child: Row(
                children: [
                  Expanded(
                    child: TrackedArcButton(
                      label: AppStrings.selfieRetake,
                      icon: AppAssetsSvg.trackedSelfieRetake,
                      isPrimary: false,
                      onTap: controller.retakeSelfie,
                    ),
                  ),
                  16.pw,
                  Expanded(
                    child: TrackedArcButton(
                      label: AppStrings.selfieConfirmCheckIn,
                      icon: AppAssetsSvg.trackedSelfieConfirm,
                      onTap: () {
                        controller.confirmCheckIn();
                        AppRouterGo.pushReplacement(trackedCheckInCompleteView);
                      },
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

class _GoodLightPill extends StatelessWidget {
  const _GoodLightPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryblack.withValues(alpha: 0.5),
        borderRadius: 100.circular,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssetsSvg.trackedSelfieLight,
            width: 12.w,
            height: 12.w,
          ),
          6.pw,
          Text(
            AppStrings.selfieGoodLight,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
              color: AppColors.trackedZoneAllowedGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityChips extends StatelessWidget {
  const _QualityChips();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final label in const [
          AppStrings.selfieAutoFlash,
          AppStrings.selfieSharp,
          AppStrings.selfieGoodLight,
        ]) ...[
          Container(
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
                  decoration: const BoxDecoration(
                    color: AppColors.trackedZoneAllowedGreen,
                    shape: BoxShape.circle,
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
          ),
          8.pw,
        ],
      ],
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64.w,
        height: 64.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryWhite.withValues(alpha: 0.2),
              blurRadius: 3,
              offset: Offset(0, 4.h),
            ),
            BoxShadow(
              color: AppColors.primaryWhite.withValues(alpha: 0.2),
              blurRadius: 7.5,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Container(
          width: 48.w,
          height: 48.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.trackedCheckInStartText),
          ),
          child: SvgPicture.asset(
            AppAssetsSvg.trackedSelfieShutter,
            width: 24.w,
            height: 24.w,
          ),
        ),
      ),
    );
  }
}
