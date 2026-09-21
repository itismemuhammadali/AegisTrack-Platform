import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_alert_entity.dart';
import '../../domain/entities/tracker_user_entity.dart';

class TrackerHomeController extends ChangeNotifier with Buffers {
  //  replace the sample data with the viewer dashboard API.
  final String viewerName = AppStrings.trackedSettingsProfileName;
  final String trackedUsersStatus = AppStrings.trackerStatActive;
  final String activeAlerts = '3';
  final String syncRate = '3';
  final String missedCheckIns = '98%';

  final String sosUserName = 'Daniel Chen';
  final String missingLogDetail = 'James Wilson · 14:30–16:00 · 90 min';

  final List<TrackerUserEntity> users = const [
    TrackerUserEntity(
      name: 'Daniel Chen',
      lastSeen: 'Today • 3:30 PM',
      location: 'Midtown Manhattan, NY',
      authenticity: TrackerAuthenticity.verified,
    ),
    TrackerUserEntity(
      name: 'Sarah Martinez',
      lastSeen: 'Today • 3:30 PM',
      location: 'Midtown Manhattan, NY',
      authenticity: TrackerAuthenticity.acceptable,
    ),
    TrackerUserEntity(
      name: 'James Wilson',
      lastSeen: 'Today • 3:30 PM',
      location: 'Midtown Manhattan, NY',
      authenticity: TrackerAuthenticity.verified,
      isOnline: false,
    ),
  ];

  final List<TrackerAlertEntity> alerts = const [
    TrackerAlertEntity(
      title: 'Restricted Zone',
      subtitle: 'Daniel',
      time: '5 min ago',
      icon: AppAssetsSvg.trackerAlertRestricted,
      color: AppColors.primaryRed,
    ),
    TrackerAlertEntity(
      title: 'Missed Check-in',
      subtitle: 'James Wilson',
      time: '2 hrs ago',
      icon: AppAssetsSvg.trackerAlertMissed,
      color: AppColors.trackerAmber,
    ),
    TrackerAlertEntity(
      title: 'Security Flag',
      subtitle: 'Sarah Martinez',
      time: '4 hrs ago',
      icon: AppAssetsSvg.trackerAlertSecurity,
      color: AppColors.trackerOrange,
    ),
  ];
}

final trackerHomeControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerHomeController>(
  (ref) => TrackerHomeController(),
);
