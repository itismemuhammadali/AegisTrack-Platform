import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../domain/entities/tracker_device_info_entity.dart';
import 'tracker_detail_text.dart';

class TrackerDeviceInfoCard extends StatelessWidget {
  const TrackerDeviceInfoCard({super.key, required this.rows});

  final List<TrackerDeviceInfoEntity> rows;

  @override
  Widget build(BuildContext context) => TrackerSurface(
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) 10.ph,
              _TrackerDeviceInfoRow(row: rows[i]),
            ],
          ],
        ),
      );
}

class _TrackerDeviceInfoRow extends StatelessWidget {
  const _TrackerDeviceInfoRow({required this.row});

  final TrackerDeviceInfoEntity row;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            flex: 2,
            child: TrackerDetailText(row.label,
                size: 12, color: AppColors.primaryWhite, height: 20 / 14),
          ),
          8.pw,
          Expanded(
            flex: 2,
            child: TrackerDetailText(row.value,
                size: 12,
                color: AppColors.primaryWhite,
                height: 20 / 14,
                monospace: true),
          ),
          8.pw,
          Flexible(
            flex: 4,
            child: Container(
              padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.trackerWarningSurface,
                borderRadius: 16.circular,
                border: Border.all(color: AppColors.trackerWarningBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppAssetsSvg.trackerSecurityLocked,
                      width: 12.w, height: 12.w),
                  6.pw,
                  const Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TrackerDetailText(
                          AppStrings.trackerLockedImmutable,
                          size: 12,
                          color: AppColors.trackerAmber,
                          weight: FontWeight.w500,
                          height: 16 / 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
