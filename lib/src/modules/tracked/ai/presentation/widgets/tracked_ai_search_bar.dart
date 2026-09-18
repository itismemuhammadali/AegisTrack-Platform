import '../../../../../core/utils/app_exports.dart';

class TrackedAiSearchBar extends StatelessWidget {
  const TrackedAiSearchBar({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.bodyMediumStyle?.copyWith(
      fontSize: 14.sp,
      height: 20 / 14,
      color: AppColors.primaryWhite,
    );

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: AppInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite.withValues(alpha: 0.05),
              borderRadius: 16.circular,
              border: Border.all(
                color: AppColors.primaryWhite.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssetsSvg.trackedAiSearchIcon,
                  width: 16.w,
                  height: 16.w,
                ),
                10.pw,
                Expanded(
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => onSubmit(),
                    cursorColor: AppColors.primaryWhite,
                    style: textStyle,
                    decoration: InputDecoration(
                      // Override the app theme's filled/outlined field so
                      // the glass container shows through (Figma).
                      isDense: true,
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: AppInsets.symmetric(vertical: 16),
                      hintText: AppStrings.trackedAiSearchHint,
                      hintStyle: textStyle?.copyWith(color: AppColors.hintGray),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        8.pw,
        GestureDetector(
          onTap: onSubmit,
          child: Container(
            padding: AppInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite.withValues(alpha: 0.05),
              borderRadius: 16.circular,
            ),
            child: Text(
              AppStrings.trackedAiSearchButton,
              style: textStyle?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.hintGray,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
