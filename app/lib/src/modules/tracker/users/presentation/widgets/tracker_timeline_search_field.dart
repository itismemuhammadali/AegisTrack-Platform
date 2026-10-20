import '../../../../../core/utils/app_exports.dart';

class TrackerTimelineSearchField extends StatelessWidget {
  const TrackerTimelineSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
        onChanged: onChanged,
        style: context.bodyMediumStyle?.copyWith(
          fontSize: 14.sp,
          color: AppColors.primaryWhite,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: AppStrings.trackerTimelineSearchHint,
          hintStyle: context.bodyMediumStyle?.copyWith(
            fontSize: 14.sp,
            color: AppColors.trackerMutedText,
            fontWeight: FontWeight.w400,
          ),
          isDense: true,
          filled: true,
          fillColor: AppColors.trackerSurfaceFill,
          prefixIcon: Padding(
            padding: AppInsets.only(left: 16, right: 16),
            child: SvgPicture.asset(AppAssetsSvg.trackerTimelineSearch,
                width: 16.w, height: 16.w),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 48.w),
          contentPadding: AppInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: 20.circular,
            borderSide: const BorderSide(color: AppColors.trackerBorderSoft),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: 20.circular,
            borderSide: const BorderSide(color: AppColors.trackerPurpleLight),
          ),
        ),
      );
}
