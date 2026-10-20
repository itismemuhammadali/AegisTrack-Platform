import '../../../../../components/custom_textfield.dart';
import '../../../../../core/utils/app_exports.dart';

class TrackedEditProfileField extends StatelessWidget {
  const TrackedEditProfileField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.svgIcon,
    this.keyboardType = TextInputType.text,
    this.isLast = false,
  });

  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final String? svgIcon;
  final TextInputType keyboardType;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final fieldFillColor = AppColors.primaryWhite.withValues(alpha: 0.05);
    final fieldBorderColor = AppColors.primaryWhite.withValues(alpha: 0.1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.labelLargeStyle?.copyWith(
            color: AppColors.primaryWhite,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.ph,
        CustomTextField(
          controller: controller,
          textInputType: keyboardType,
          isLast: isLast,
          isPrefix: true,
          prefixWidget: svgIcon != null
              ? SvgPicture.asset(
                  svgIcon!,
                  width: 20.sp,
                  height: 20.sp,
                  colorFilter: const ColorFilter.mode(
                    AppColors.hintGray,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(icon, size: 20.sp, color: AppColors.hintGray),
          textStyle: context.bodyLargeStyle?.copyWith(
            color: AppColors.primaryWhite,
            fontSize: 16.sp,
          ),
          hintTextStyle: context.bodyLargeStyle?.copyWith(
            color: AppColors.hintGray,
            fontSize: 16.sp,
          ),
          fillColor: fieldFillColor,
          enableBorderColor: fieldBorderColor,
          focusedBorderColor: fieldBorderColor,
          fieldBorderRadius: 16,
          contentPadding: AppInsets.all(16),
        ),
      ],
    );
  }
}
