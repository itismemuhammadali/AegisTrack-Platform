import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../controller/tracker_users_controller.dart';
import '../widgets/tracker_detail_scaffold.dart';
import '../widgets/tracker_detail_text.dart';
import '../widgets/tracker_device_info_card.dart';
import '../widgets/tracker_security_check_card.dart';
import '../widgets/tracker_security_footer_button.dart';
import '../widgets/tracker_security_notice.dart';
import '../widgets/tracker_security_score_card.dart';
import '../widgets/tracker_security_section_title.dart';

/// Read-only security report for an assigned user.
class TrackerSecurityDetailsView extends ConsumerWidget {
  const TrackerSecurityDetailsView({
    super.key,
    this.user,
    this.onViewRelatedLog,
    this.onDownloadReport,
  });

  /// The subject the report belongs to. Absent when the report is opened
  /// from a log record rather than from a user's overview.
  final TrackerUserEntity? user;
  final VoidCallback? onViewRelatedLog;
  final VoidCallback? onDownloadReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerUsersControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerSecurityDetails,
      backTooltip: AppStrings.trackerBackToUserOverview,
      titleColor: AppColors.primaryWhite,
      backgroundColor: AppColors.onboardingScrimNavy,
      scrimColor: AppColors.trackerSecurityScrimSlate,
      secondaryScrimColor: AppColors.trackerSecurityScrimNavy,
      scrimAlpha: .6,
      midScrimAlpha: .6,
      child: ListView(
        key: const PageStorageKey('tracker-security-details'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerSecurityScoreCard(score: controller.securityScore),
          24.ph,
          const TrackerSecuritySectionTitle(
              AppStrings.trackerSecurityChecksTitle),
          10.ph,
          for (final check in controller.primaryChecks) ...[
            TrackerSecurityCheckCard(check: check),
            10.ph,
          ],
          TrackerSecurityNotice(
            color: AppColors.trackerWarningAmber,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(AppAssetsSvg.trackerSecurityWarning,
                    width: 16.w, height: 16.w),
                8.pw,
                const Expanded(
                  child: TrackerDetailText(AppStrings.trackerVpnNotice,
                      size: 12,
                      color: AppColors.trackerWarningText,
                      height: 19.5 / 12),
                ),
              ],
            ),
          ),
          for (final check in controller.secondaryChecks) ...[
            10.ph,
            TrackerSecurityCheckCard(check: check),
          ],
          24.ph,
          const TrackerSecuritySectionTitle(
              AppStrings.trackerSecurityDeviceTitle),
          10.ph,
          TrackerDeviceInfoCard(rows: controller.deviceInfo),
          24.ph,
          TrackerSecurityFooterButton(AppStrings.trackerViewRelatedLog,
              primary: true, onTap: onViewRelatedLog),
          10.ph,
          TrackerSecurityFooterButton(AppStrings.trackerDownloadSecurityReport,
              icon: AppAssetsSvg.trackerSecurityDownload,
              onTap: onDownloadReport),
          24.ph,
          TrackerSecurityNotice(
            color: AppColors.trackerInfoBlueStrong,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 16.w,
                  height: 16.w,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.trackerInfoBlueSurface,
                  ),
                  child: const TrackerDetailText('i',
                      size: 10,
                      weight: FontWeight.w700,
                      color: AppColors.trackerInfoBlue),
                ),
                8.pw,
                const Expanded(
                  child: TrackerDetailText(AppStrings.trackerReadOnlyNotice,
                      size: 12,
                      color: AppColors.trackerInfoBlueText,
                      height: 19.5 / 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
