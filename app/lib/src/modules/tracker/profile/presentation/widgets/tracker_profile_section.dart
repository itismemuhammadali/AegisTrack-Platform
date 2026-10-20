import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';
import 'tracker_profile_row.dart';

class TrackerProfileSection extends StatelessWidget {
  const TrackerProfileSection(
      {super.key, required this.section, required this.onRowTap});

  final TrackerProfileSectionEntity section;
  final VoidCallback? Function(TrackerProfileRowEntity row) onRowTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: .6,
              color: AppColors.trackerMutedText,
            ),
          ),
          10.ph,
          TrackerSurface(
            padding: 0,
            borderColor: AppColors.trackerSurfaceFill,
            child: Column(
              children: [
                for (var i = 0; i < section.rows.length; i++) ...[
                  if (i > 0)
                    const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.trackerBorderSoft),
                  TrackerProfileRow(
                    row: section.rows[i],
                    onTap: onRowTap(section.rows[i]),
                  ),
                ],
              ],
            ),
          ),
          24.ph,
        ],
      );
}
