import '../../../../../core/utils/app_exports.dart';

class TrackerUsersSearchField extends StatelessWidget {
  const TrackerUsersSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.bodyMediumStyle?.copyWith(
      fontSize: 14.sp,
      color: AppColors.primaryWhite,
      fontWeight: FontWeight.w400,
    );
    return TextField(
      onChanged: onChanged,
      style: textStyle,
      decoration: InputDecoration(
        hintText: AppStrings.trackerUsersSearchHint,
        hintStyle: textStyle,
        isDense: true,
        filled: true,
        fillColor: AppColors.trackerSurfaceFill,
        contentPadding: AppInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: 20.circular,
          borderSide: const BorderSide(color: AppColors.trackerSurfaceFill),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: 20.circular,
          borderSide: const BorderSide(color: AppColors.trackerPurpleLight),
        ),
      ),
    );
  }
}
