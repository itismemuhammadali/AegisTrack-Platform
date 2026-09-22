import '../../../../../components/custom_textfield.dart';
import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';

/// Avatar with the camera button that changes the profile photo.
class TrackerEditProfileAvatar extends StatelessWidget {
  const TrackerEditProfileAvatar({
    super.key,
    required this.initials,
    this.onChangePhoto,
  });

  final String initials;
  final VoidCallback? onChangePhoto;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(
            width: 112.w,
            height: 112.w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 112.w,
                  height: 112.w,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.trackerEditAvatarTop,
                        AppColors.trackerEditAvatarBottom,
                      ],
                    ),
                  ),
                  child: TrackerDetailText(initials,
                      size: 30, weight: FontWeight.w600, height: 36 / 30),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: onChangePhoto,
                    child: Container(
                      padding: AppInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.trackerPurpleDeep,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.authToggleShadow,
                            blurRadius: 7.5,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                          AppAssetsSvg.trackerEditProfileCamera,
                          width: 20.w,
                          height: 20.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.ph,
          GestureDetector(
            onTap: onChangePhoto,
            child: const TrackerDetailText(
                AppStrings.trackerEditProfileChangePhoto,
                weight: FontWeight.w500,
                height: 20 / 14,
                color: AppColors.primaryWhite),
          ),
        ],
      );
}

/// A labelled field. [lines] > 1 renders the bio's taller box.
class TrackerEditProfileField extends StatelessWidget {
  const TrackerEditProfileField({
    super.key,
    required this.label,
    required this.controller,
    this.lines = 1,
    this.filled = false,
    this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
  });

  final String label;
  final TextEditingController controller;
  final int lines;

  /// The Location field sits on a filled surface in the design; the rest are
  /// outlined only.
  final bool filled;

  final String? hint;
  final bool obscure;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrackerDetailText(label,
              weight: FontWeight.w500,
              height: 20 / 14,
              color: AppColors.primaryWhite),
          6.ph,
          CustomTextField(
            controller: controller,
            maxLines: obscure ? 1 : lines,
            minLines: obscure ? 1 : lines,
            isObscure: obscure,
            hintText: hint,
            textInputType: lines > 1 ? TextInputType.multiline : keyboardType,
            fillColor:
                filled ? AppColors.trackerSurfaceFill : AppColors.transparent,
            enableBorderColor: AppColors.trackerSurfaceFill,
            focusedBorderColor: AppColors.trackerBorderSoft,
            cursorColor: AppColors.primaryWhite,
            fieldBorderRadius: 20,
            contentPadding: AppInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: context.bodyLargeStyle?.copyWith(
              fontSize: 16.sp,
              height: 24 / 16,
              color: AppColors.primaryWhite,
            ),
            hintTextStyle: context.bodyLargeStyle?.copyWith(
              fontSize: 16.sp,
              height: 24 / 16,
              color: AppColors.trackerMutedText,
            ),
          ),
        ],
      );
}
