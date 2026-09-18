import '../../../../../core/utils/app_exports.dart';
import 'tracked_log_details_section.dart';

class TrackedLogDetailsAdditionalNotes extends StatelessWidget {
  const TrackedLogDetailsAdditionalNotes({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(AppAssetsSvg.trackedLogDetailsNotes,
                  width: 16.w),
              8.pw,
              Text(AppStrings.trackedLogDetailsAdditionalNotes,
                  style: TextStyle(
                      color: AppColors.primaryWhite,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              SvgPicture.asset(AppAssetsSvg.trackedLogDetailsAdd, width: 16.w),
              4.pw,
              Text(AppStrings.addNote,
                  style: TextStyle(
                      color: AppColors.primaryWhite,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          10.ph,
          TrackedLogDetailsGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.trackedLogDetailsFollowUp,
                    style: TextStyle(
                        color: AppColors.primaryWhite,
                        fontSize: 14.sp,
                        height: 1.625)),
                10.ph,
                Text(AppStrings.trackedLogDetailsFollowUpTime,
                    style: TextStyle(
                        color: AppColors.trackedLogTagText,
                        fontSize: 12.sp,
                        height: 16 / 12)),
              ],
            ),
          ),
        ],
      );
}
