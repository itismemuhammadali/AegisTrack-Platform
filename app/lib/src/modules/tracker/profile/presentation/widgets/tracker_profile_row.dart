import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';

class TrackerProfileRow extends StatelessWidget {
  const TrackerProfileRow({super.key, required this.row, this.onTap});

  final TrackerProfileRowEntity row;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.trackerSurfaceFill,
                  borderRadius: 16.circular,
                ),
                child: SvgPicture.asset(row.icon, width: 16.w, height: 16.w),
              ),
              12.pw,
              Expanded(
                child: Text(
                  row.label,
                  style: context.bodyMediumStyle?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.viewerSignInText,
                  ),
                ),
              ),
              if (row.value.isNotEmpty) ...[
                8.pw,
                if (row.valueIsBadge)
                  TrackerBadge(row.value,
                      background: AppColors.trackerSurfaceFill)
                else
                  Text(
                    row.value,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: row.valueColor ?? AppColors.trackerMutedText,
                    ),
                  ),
              ],
              8.pw,
              SvgPicture.asset(AppAssetsSvg.trackerProfileChevron,
                  width: 16.w, height: 16.w),
            ],
          ),
        ),
      );
}
