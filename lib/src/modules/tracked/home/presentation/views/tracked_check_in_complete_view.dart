import 'package:intl/intl.dart';

import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/presentation/widgets/tracked_subscription_scaffold.dart';
import '../controller/tracked_home_controller.dart';
import '../widgets/tracked_arc_action_bar.dart';

class TrackedCheckInCompleteView extends ConsumerWidget {
  const TrackedCheckInCompleteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedHomeControllerProvider);
    final timestamp = DateFormat('hh:mm a · MMMM d, yyyy')
        .format(controller.completedAt ?? DateTime.now());
    const green = AppColors.trackedZoneAllowedGreen;

    final rows = [
      (
        AppAssetsSvg.trackedCompleteBiometric,
        AppStrings.checkInBiometricVerified,
        AppStrings.checkInConfirmed,
        green,
      ),
      // Only the Face ID path captures a selfie.
      if (controller.selfie != null)
        (
          AppAssetsSvg.trackedCompleteSelfie,
          AppStrings.checkInSelfieCaptured,
          AppStrings.checkInSecured,
          green,
        ),
      (
        AppAssetsSvg.trackedCompleteLocation,
        AppStrings.checkInLocationCaptured,
        // use the location captured with the check-in.
        '37.7749° N, 122.4194° W',
        green,
      ),
      (
        AppAssetsSvg.trackedCompleteTimestamp,
        AppStrings.checkInTimestamp,
        timestamp,
        AppColors.signInDarkSubtitle,
      ),
      (
        AppAssetsSvg.trackedCompleteSynced,
        AppStrings.checkInSecurelySynced,
        AppStrings.checkInCompleteValue,
        green,
      ),
    ];

    return PopScope(
      canPop: false,
      child: TrackedSubscriptionScaffold(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppInsets.all(24),
                children: [
                  Center(
                    child: Container(
                      width: 96.w,
                      height: 96.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssetsSvg.trackedCheckInComplete,
                        width: 48.w,
                        height: 48.w,
                      ),
                    ),
                  ),
                  24.ph,
                  Text(
                    AppStrings.checkInCompleteTitle,
                    textAlign: TextAlign.center,
                    style: context.headlineSmallStyle?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      height: 32 / 24,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  10.ph,
                  Text(
                    AppStrings.checkInCompleteSubtitle,
                    textAlign: TextAlign.center,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      color: AppColors.signInDarkSubtitle,
                    ),
                  ),
                  24.ph,
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.primaryWhite.withValues(alpha: 0.05),
                      borderRadius: 16.circular,
                      border: Border.all(
                        color: AppColors.primaryWhite.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < rows.length; i++)
                          _SummaryRow(
                            icon: rows[i].$1,
                            label: rows[i].$2,
                            value: rows[i].$3,
                            valueColor: rows[i].$4,
                            showDivider: i < rows.length - 1,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TrackedArcActionBar(
              child: TrackedArcButton(
                label: AppStrings.checkInDone,
                onTap: () {
                  controller.resetCheckIn();
                  // Dashboard opens on the Home tab.
                  AppRouterGo.pushRemoveUntil(trackedDashboardView);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.showDivider,
  });

  final String icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final style = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 16 / 12,
    );

    return Container(
      padding: AppInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.primaryWhite.withValues(alpha: 0.1),
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite.withValues(alpha: 0.05),
              borderRadius: 14.circular,
            ),
            child: SvgPicture.asset(icon, width: 16.w, height: 16.w),
          ),
          16.pw,
          Expanded(
            child: Text(
              label,
              style: style?.copyWith(color: AppColors.signInDarkSubtitle),
            ),
          ),
          Text(
            value,
            style: style?.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
