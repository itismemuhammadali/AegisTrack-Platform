import '../../../../../core/utils/app_exports.dart';
import '../widgets/live_location_status_card.dart';
import '../widgets/live_map_card.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/tracked_home_header.dart';

class TrackedHomeView extends StatelessWidget {
  const TrackedHomeView({
    super.key,
    this.onViewFullMap,
    this.onLogNow,
    this.onAddNote,
    this.onCapture,
  });

  final VoidCallback? onViewFullMap;
  final VoidCallback? onLogNow;
  final VoidCallback? onAddNote;
  final VoidCallback? onCapture;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TrackedHomeHeader(),
          24.ph,
          const LiveLocationStatusCard(),
          24.ph,
          Expanded(child: LiveMapCard(onViewFullMap: onViewFullMap)),
          24.ph,
          QuickActionsSection(
            onLogNow: onLogNow,
            onAddNote: onAddNote,
            onCapture: onCapture,
          ),
        ],
      ),
    );
  }
}
