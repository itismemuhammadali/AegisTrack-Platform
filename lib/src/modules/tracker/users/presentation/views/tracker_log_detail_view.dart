import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_log_detail_entity.dart';
import '../controller/tracker_users_controller.dart';
import '../widgets/tracker_detail_scaffold.dart';
import '../widgets/tracker_detail_text.dart';
import '../widgets/tracker_log_header_card.dart';
import '../widgets/tracker_log_media_card.dart';
import '../widgets/tracker_log_score_card.dart';
import '../widgets/tracker_log_section_card.dart';

/// A single sealed GPS log, opened from a recent activity row or an alert.
class TrackerLogDetailView extends ConsumerWidget {
  const TrackerLogDetailView({
    super.key,
    this.onViewOnMap,
    this.onSecurityDetails,
  });

  final VoidCallback? onViewOnMap;
  final VoidCallback? onSecurityDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerUsersControllerProvider);
    final log = controller.logDetail;

    return TrackerDetailScaffold(
      title: AppStrings.trackerLogDetail,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerLogBackTooltip,
      banner: const _TrackerLogLockedBanner(),
      child: ListView(
        key: const PageStorageKey('tracker-log-detail'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerLogHeaderCard(log: log),
          24.ph,
          TrackerLogSectionCard(
            title: AppStrings.trackerLogGpsSection,
            icon: AppAssetsSvg.trackerLogGps,
            fields: log.gpsFields,
          ),
          24.ph,
          TrackerLogScoreCard(
            log: log,
            bands: TrackerUsersController.scoreBands,
            onSecurityDetails: onSecurityDetails,
          ),
          24.ph,
          TrackerLogSectionCard(
            title: AppStrings.trackerLogSyncSection,
            icon: AppAssetsSvg.trackerLogSync,
            fields: log.syncFields,
          ),
          24.ph,
          TrackerLogSectionCard(
            title: AppStrings.trackerLogEventSection,
            fields: [
              TrackerLogFieldEntity(
                label: AppStrings.trackerLogEventType,
                value: log.kindLabel,
              ),
              ...log.eventFields,
            ],
            trailing: _TrackerLogNotes(log: log),
          ),
          24.ph,
          TrackerLogMediaCard(caption: log.mediaCaption),
          24.ph,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TrackerLogFooterButton(
                    label: AppStrings.trackerLogViewOnMap,
                    icon: AppAssetsSvg.trackerLogGps,
                    onTap: onViewOnMap,
                  ),
                ),
                12.pw,
                Expanded(
                  child: TrackerLogFooterButton(
                    label: AppStrings.trackerLogSecurityDetails,
                    icon: AppAssetsSvg.trackerLogSecurity,
                    onTap: onSecurityDetails,
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

/// Amber strip above the header stating the record cannot be edited.
class _TrackerLogLockedBanner extends StatelessWidget {
  const _TrackerLogLockedBanner();

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: const BoxDecoration(
          color: AppColors.trackerWarningSurface,
          border: Border(
              bottom: BorderSide(color: AppColors.trackerLogBannerBorder)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(AppAssetsSvg.trackerLogLockBanner,
                width: 16.w, height: 16.w),
            8.pw,
            Expanded(
              child: Text(
                AppStrings.trackerLogLockedBanner,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.trackerAmber,
                ),
              ),
            ),
          ],
        ),
      );
}

/// The event's free-text note, in its own rounded well.
class _TrackerLogNotes extends StatelessWidget {
  const _TrackerLogNotes({required this.log});

  final TrackerLogDetailEntity log;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          6.ph,
          const TrackerDetailText(AppStrings.trackerLogNotes,
              size: 12, height: 16 / 12, color: AppColors.primaryWhite),
          6.ph,
          Container(
            width: double.infinity,
            padding: AppInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.trackerSurfaceFill,
              borderRadius: 20.circular,
            ),
            child: TrackerDetailText(log.notes, height: 20 / 14),
          ),
          6.ph,
          Row(
            children: [
              SvgPicture.asset(AppAssetsSvg.trackerLogCamera,
                  width: 16.w, height: 16.w),
              8.pw,
              Expanded(
                child: TrackerDetailText(log.attachmentSummary,
                    size: 12, height: 16 / 12, color: AppColors.primaryWhite),
              ),
            ],
          ),
        ],
      );
}
