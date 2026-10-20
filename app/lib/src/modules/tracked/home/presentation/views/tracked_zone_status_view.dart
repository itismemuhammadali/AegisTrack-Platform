import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/presentation/widgets/tracked_subscription_scaffold.dart';
import '../../domain/entities/tracked_zone_event_entity.dart';
import '../widgets/tracked_zone_event_card.dart';
import '../widgets/tracked_zone_map_preview.dart';
import '../widgets/tracked_zone_summary_card.dart';

class TrackedZoneStatusView extends StatelessWidget {
  const TrackedZoneStatusView({super.key});

  // replace with geofence events from the tracking service.
  static const _events = [
    TrackedZoneEventEntity(
      title: 'Entered Zone',
      zone: 'Work Site Alpha',
      time: '10:24 AM',
      coordinates: '37.7749° N, 122.4194° W',
      color: AppColors.trackedZoneAllowedGreen,
    ),
    TrackedZoneEventEntity(
      title: 'Restricted Alert',
      zone: 'Zone B — Restricted',
      time: '9:12 AM',
      coordinates: '37.7751° N, 122.4188° W',
      color: AppColors.trackedSosRed,
    ),
    TrackedZoneEventEntity(
      title: 'Exited Zone',
      zone: 'Residential Area',
      time: '8:03 AM',
      coordinates: '37.7739° N, 122.4220° W',
      color: AppColors.signInDarkSubtitle,
    ),
    TrackedZoneEventEntity(
      title: 'Check-in Required',
      zone: 'Central Office',
      time: 'Yesterday 5:00 PM',
      coordinates: '37.7740° N, 122.4198° W',
      color: AppColors.trackedCheckInAmber,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TrackedSubscriptionScaffold(
      title: AppStrings.zoneStatusTitle,
      subtitle: AppStrings.zoneStatusSubtitle,
      subtitleColor: AppColors.primaryWhite.withValues(alpha: 0.6),
      child: ListView(
        padding: AppInsets.only(left: 24, right: 24, top: 16, bottom: 24),
        children: [
          const TrackedZoneSummaryCard(),
          24.ph,
          const TrackedZoneMapPreview(),
          24.ph,
          Text(
            AppStrings.zoneStatusRecentEvents.toUpperCase(),
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
              letterSpacing: 0.3,
              color: AppColors.hintGray,
            ),
          ),
          for (final event in _events) ...[
            if (event == _events.first) 16.ph else 10.ph,
            TrackedZoneEventCard(event: event),
          ],
        ],
      ),
    );
  }
}
