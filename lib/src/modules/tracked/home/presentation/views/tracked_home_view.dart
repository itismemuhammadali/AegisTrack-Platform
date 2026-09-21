import '../../../../../core/utils/app_exports.dart';
import '../widgets/live_map_card.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/tracked_ask_ai_bar.dart';
import '../widgets/tracked_home_header.dart';
import '../widgets/tracked_home_stats_grid.dart';

class TrackedHomeView extends StatelessWidget {
  const TrackedHomeView({
    super.key,
    this.onViewFullMap,
    this.onLogNow,
    this.onAddNote,
    this.onCapture,
    this.onCheckIn,
    this.onSos,
    this.onAskAi,
    this.onZone,
    this.onSyncStatus,
  });

  final VoidCallback? onViewFullMap;
  final VoidCallback? onLogNow;
  final VoidCallback? onAddNote;
  final VoidCallback? onCapture;
  final VoidCallback? onCheckIn;
  final VoidCallback? onSos;
  final VoidCallback? onAskAi;
  final VoidCallback? onZone;

  /// Tapping the Last Synced / Failed cards opens Sync Status.
  final VoidCallback? onSyncStatus;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppInsets.only(top: 24, bottom: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrackedHomeHeader(onSos: onSos),
          24.ph,
          TrackedHomeStatsGrid(
            onCheckIn: onCheckIn,
            onZone: onZone,
            onLastSynced: onSyncStatus,
            onFailed: onSyncStatus,
          ),
          24.ph,
          LiveMapCard(onViewFullMap: onViewFullMap),
          24.ph,
          QuickActionsSection(
            onLogNow: onLogNow,
            onAddNote: onAddNote,
            onCapture: onCapture,
            onCheckIn: onCheckIn,
          ),
          24.ph,
          TrackedAskAiBar(onTap: onAskAi),
        ],
      ),
    );
  }
}
