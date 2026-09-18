import '../../../../../core/utils/app_exports.dart';
import '../widgets/tracked_sos_hold_button.dart';
import '../widgets/tracked_sos_info_card.dart';

class TrackedSosView extends StatelessWidget {
  const TrackedSosView({super.key, this.onActivated});

  final VoidCallback? onActivated;

  void _activate() {
    //  capture location, notify viewer and create the emergency log.
    Prompts.showToast(AppStrings.sosAlertSent);
    onActivated?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trackedLogCaptureHeaderBackdrop,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
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
          ),
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: AppInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: 16,
                  ),
                  child: const _SosHeader(),
                ),
              ),
              24.ph,
              Expanded(
                child: SingleChildScrollView(
                  padding: AppInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const TrackedSosInfoCard(),
                      24.ph,
                      TrackedSosHoldButton(onActivated: _activate),
                      10.ph,
                      Text(
                        AppStrings.sosHoldHint,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          height: 16 / 12,
                          color: AppColors.hintGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const _SosCancelBar(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SosHeader extends StatelessWidget {
  const _SosHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppBackButton(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.trackedSosRed.withValues(alpha: 0.2),
                  borderRadius: 18.circular,
                ),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedSosHeaderAlert,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
              12.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.sosEmergency,
                    style: context.titleLargeStyle?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      height: 28 / 20,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  Text(
                    AppStrings.sosHoldToActivate,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      color: AppColors.trackedSosRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: AppRouterGo.back,
          child: Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite.withValues(alpha: 0.05),
              borderRadius: 18.circular,
              border: Border.all(
                color: AppColors.primaryWhite.withValues(alpha: 0.1),
              ),
            ),
            child: SvgPicture.asset(
              AppAssetsSvg.trackedSosClose,
              width: 20.w,
              height: 20.w,
            ),
          ),
        ),
      ],
    );
  }
}

/// Figma: 112px strip with the top of a 1192px navy ellipse and a centred
/// 320px "Cancel — I am safe" button 42px from the top.
class _SosCancelBar extends StatelessWidget {
  const _SosCancelBar();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: 112.h + bottomInset,
      width: double.infinity,
      child: ClipRect(
        child: Stack(
          children: [
            OverflowBox(
              alignment: Alignment.topCenter,
              minWidth: 0,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: SvgPicture.asset(
                AppAssetsSvg.trackedSosBottomArc,
                width: 1192.w,
                height: 596.w,
              ),
            ),
            Positioned(
              top: 42.h,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: AppRouterGo.back,
                  child: Container(
                    width: 320.w,
                    padding: AppInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryWhite.withValues(alpha: 0.05),
                      borderRadius: 16.circular,
                      border: Border.all(
                        color: AppColors.primaryWhite.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      AppStrings.sosCancelSafe,
                      style: context.bodyMediumStyle?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
