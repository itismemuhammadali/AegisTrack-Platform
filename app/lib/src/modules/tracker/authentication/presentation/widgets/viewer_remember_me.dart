import '../../../../../core/utils/app_exports.dart';

/// "Remember Me" checkbox used on the viewer sign-in screen.
class ViewerRememberMe extends StatelessWidget {
  const ViewerRememberMe({
    super.key,
    required this.value,
    required this.onTap,
  });

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: value ? AppColors.twoFactorAccentPurple : null,
              borderRadius: 4.circular,
              border: Border.all(
                color: value
                    ? AppColors.twoFactorAccentPurple
                    : AppColors.primaryWhite.withValues(alpha: 0.2),
              ),
            ),
            child: value
                ? Icon(
                    Icons.check_rounded,
                    size: 14.sp,
                    color: AppColors.primaryWhite,
                  )
                : null,
          ),
          8.pw,
          Text(
            AppStrings.rememberMe,
            style: context.bodyMediumStyle?.copyWith(
              color: AppColors.viewerSignInText,
              fontSize: 14.sp,
              height: 20 / 14,
            ),
          ),
        ],
      ),
    );
  }
}
