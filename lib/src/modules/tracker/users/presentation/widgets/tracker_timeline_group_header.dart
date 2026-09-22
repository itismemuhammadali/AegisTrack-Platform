import '../../../../../core/utils/app_exports.dart';

class TrackerTimelineGroupHeader extends StatelessWidget {
  const TrackerTimelineGroupHeader(
      {super.key, required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(
            title.toUpperCase(),
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              height: 16 / 12,
              fontWeight: FontWeight.w600,
              letterSpacing: .6,
              color: AppColors.primaryWhite,
            ),
          ),
          8.pw,
          const Expanded(
            child: Divider(height: 1, color: AppColors.trackerBorderSoft),
          ),
          8.pw,
          Text(
            '$count ${AppStrings.trackerTimelineLogsSuffix}',
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              height: 16 / 12,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryWhite,
            ),
          ),
        ],
      );
}
