import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_zone_event_entity.dart';
import 'tracker_detail_surface.dart';
import 'tracker_detail_text.dart';

class TrackerZoneEventsCard extends StatelessWidget {
  const TrackerZoneEventsCard({super.key, required this.events});

  final List<TrackerZoneEventEntity> events;

  @override
  Widget build(BuildContext context) => TrackerDetailSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TrackerDetailText(AppStrings.trackerZoneEventsToday,
                weight: FontWeight.w600),
            for (final event in events) ...[
              10.ph,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrackerDetailText(event.time,
                      size: 12, color: AppColors.trackerMutedText),
                  12.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TrackerDetailText(event.title, weight: FontWeight.w600),
                        TrackerDetailText(event.place,
                            size: 12, color: AppColors.trackerMutedText),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
}
