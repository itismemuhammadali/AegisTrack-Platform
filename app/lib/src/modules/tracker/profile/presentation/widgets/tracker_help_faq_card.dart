import '../../../../../core/utils/app_exports.dart';

/// A collapsible FAQ row. The design only specifies the collapsed state, so
/// tapping rotates the chevron and leaves the answer to a later pass.
class TrackerHelpFaqCard extends StatelessWidget {
  const TrackerHelpFaqCard({
    super.key,
    required this.question,
    required this.expanded,
    this.onTap,
  });

  final String question;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: AppInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.trackerSurfaceFill,
            borderRadius: 16.circular,
            border: Border.all(color: AppColors.trackerSurfaceFill),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  question,
                  style: context.bodyMediumStyle?.copyWith(
                    fontSize: 14.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.viewerSignInText,
                  ),
                ),
              ),
              8.pw,
              RotatedBox(
                quarterTurns: expanded ? 2 : 0,
                child: SvgPicture.asset(AppAssetsSvg.trackerHelpFaqChevron,
                    width: 16.w, height: 16.w),
              ),
            ],
          ),
        ),
      );
}
