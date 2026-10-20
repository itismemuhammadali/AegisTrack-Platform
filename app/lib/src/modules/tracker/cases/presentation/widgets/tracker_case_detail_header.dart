import '../../../../../core/utils/app_exports.dart';

/// Case detail header: reference number, title with its status badge, and a
/// close button in place of the back arrow the other detail screens use.
class TrackerCaseDetailHeader extends StatelessWidget {
  const TrackerCaseDetailHeader({
    super.key,
    required this.id,
    required this.title,
    required this.status,
    required this.statusColor,
  });

  final String id;
  final String title;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 1.2,
                    color: AppColors.trackerMutedText,
                  ),
                ),
                10.ph,
                Wrap(
                  spacing: 10.w,
                  runSpacing: 6.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: context.titleMediumStyle?.copyWith(
                        fontSize: 18.sp,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.viewerSignInText,
                      ),
                    ),
                    Container(
                      padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.trackerSuccessSurface,
                        borderRadius: 100.circular,
                      ),
                      child: Text(
                        status,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          height: 1.2,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          16.pw,
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: IconButton(
              tooltip: AppStrings.trackerCaseDetailClose,
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.trackerSurfaceFill,
                shape: RoundedRectangleBorder(
                  borderRadius: 100.circular,
                  side: const BorderSide(color: AppColors.trackerSurfaceFill),
                ),
              ),
              icon: SvgPicture.asset(
                AppAssetsSvg.trackerCaseDetailClose,
                width: 16.w,
                height: 16.w,
              ),
            ),
          ),
        ],
      );
}
