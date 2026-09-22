import '../../../../../core/utils/app_exports.dart';

class TrackerSecurityCheckEntity {
  const TrackerSecurityCheckEntity({
    required this.label,
    this.status = AppStrings.trackerStatusPassed,
    this.icon = AppAssetsSvg.trackerSecurityPassed,
    this.color = AppColors.trackerOnlineGreen,
    this.background = AppColors.trackerSuccessSurface,
    this.description,
  });

  final String label;
  final String status;
  final String icon;
  final Color color;
  final Color background;
  final String? description;
}
