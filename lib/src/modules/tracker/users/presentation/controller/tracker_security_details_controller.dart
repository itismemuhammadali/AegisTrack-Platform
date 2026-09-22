import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_device_info_entity.dart';
import '../../domain/entities/tracker_security_check_entity.dart';

/// Read-only security report using the supplied Figma sample log results.
class TrackerSecurityDetailsController extends ChangeNotifier with Buffers {
  final String score = AppStrings.trackerAuthenticityScoreValue;

  /// Checks rendered above the VPN advisory notice.
  final List<TrackerSecurityCheckEntity> primaryChecks = const [
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckMockLocation),
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckFakeGps),
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckRoot),
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckAppIntegrity),
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckDeviceIntegrity),
    TrackerSecurityCheckEntity(
      label: AppStrings.trackerCheckVpn,
      status: AppStrings.trackerStatusFlagged,
      icon: AppAssetsSvg.trackerSecurityFlagged,
      color: AppColors.trackerFlaggedRed,
      background: AppColors.trackerDangerSurface,
      description: AppStrings.trackerVpnDetected,
    ),
  ];

  /// Checks rendered below the VPN advisory notice.
  final List<TrackerSecurityCheckEntity> secondaryChecks = const [
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckClock),
    TrackerSecurityCheckEntity(
      label: AppStrings.trackerCheckBluetooth,
      status: AppStrings.trackerStatusUnavailable,
      icon: AppAssetsSvg.trackerSecurityUnavailable,
      color: AppColors.primaryWhite,
      background: AppColors.trackerBorderSoft,
      description: AppStrings.trackerBluetoothDisabled,
    ),
    TrackerSecurityCheckEntity(
      label: AppStrings.trackerCheckSuspicious,
      status: AppStrings.trackerStatusUnderReview,
      icon: AppAssetsSvg.trackerSecurityReview,
      color: AppColors.trackerInfoBlue,
      background: AppColors.trackerInfoBlueSurface,
      description: AppStrings.trackerPatternAnalysis,
    ),
  ];

  final List<TrackerDeviceInfoEntity> deviceInfo = const [
    TrackerDeviceInfoEntity(
        label: AppStrings.trackerDeviceModel, value: 'iPhone 14 Pro'),
    TrackerDeviceInfoEntity(
        label: AppStrings.trackerDeviceOs, value: 'iOS 17.2.1'),
    TrackerDeviceInfoEntity(
        label: AppStrings.trackerAppVersionLabel, value: '3.4.2 (Build 441)'),
    TrackerDeviceInfoEntity(
        label: AppStrings.trackerDeviceId, value: '••••7f3a'),
  ];
}

final trackerSecurityDetailsControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerSecurityDetailsController>(
  (ref) => TrackerSecurityDetailsController(),
);
