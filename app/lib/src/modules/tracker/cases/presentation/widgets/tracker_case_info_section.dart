import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../domain/entities/tracker_case_entity.dart';

/// Case information: label/value rows separated by hairlines, the last row
/// running without one.
class TrackerCaseInfoSection extends StatelessWidget {
  const TrackerCaseInfoSection({super.key, required this.rows});

  final List<TrackerCaseInfoEntity> rows;

  @override
  Widget build(BuildContext context) => TrackerSurface(
        padding: 0,
        borderColor: AppColors.trackerSurfaceFill,
        child: Padding(
          padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.trackerCaseInformation,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.trackerMutedText,
                ),
              ),
              14.ph,
              for (var i = 0; i < rows.length; i++) ...[
                _TrackerCaseInfoRow(row: rows[i], divided: i < rows.length - 1),
                if (i < rows.length - 1) 10.ph,
              ],
            ],
          ),
        ),
      );
}

class _TrackerCaseInfoRow extends StatelessWidget {
  const _TrackerCaseInfoRow({required this.row, required this.divided});

  final TrackerCaseInfoEntity row;
  final bool divided;

  @override
  Widget build(BuildContext context) {
    final label = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 16 / 12,
      color: AppColors.trackerMutedText,
    );

    return Container(
      padding: divided ? AppInsets.only(bottom: 6) : EdgeInsets.zero,
      decoration: divided
          ? const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColors.trackerSurfaceFill)),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.label, style: label),
          8.pw,
          Expanded(
            child: Text(
              row.value,
              textAlign: TextAlign.right,
              style: label?.copyWith(color: AppColors.viewerSignInText),
            ),
          ),
        ],
      ),
    );
  }
}
