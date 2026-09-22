import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_detail_info_entity.dart';
import 'tracker_detail_text.dart';

class TrackerUserInfoTile extends StatelessWidget {
  const TrackerUserInfoTile({super.key, required this.info});

  final TrackerDetailInfoEntity info;

  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(minHeight: 66.h),
        padding: AppInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TrackerDetailText(info.label,
                size: 12, color: AppColors.trackerMutedText),
            10.ph,
            // Long locations retain the design's single line at narrow widths.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: TrackerDetailText(info.value, weight: FontWeight.w600),
            ),
          ],
        ),
      );
}

/// Two-column grid of [TrackerUserInfoTile]s; a trailing odd tile spans a row.
class TrackerUserInfoGrid extends StatelessWidget {
  const TrackerUserInfoGrid({super.key, required this.tiles});

  final List<TrackerDetailInfoEntity> tiles;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (var i = 0; i + 1 < tiles.length; i += 2) ...[
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: TrackerUserInfoTile(info: tiles[i])),
                  8.pw,
                  Expanded(child: TrackerUserInfoTile(info: tiles[i + 1])),
                ],
              ),
            ),
            10.ph,
          ],
          if (tiles.length.isOdd) TrackerUserInfoTile(info: tiles.last),
        ],
      );
}
