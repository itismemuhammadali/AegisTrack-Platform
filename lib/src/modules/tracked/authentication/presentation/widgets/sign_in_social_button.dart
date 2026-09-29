import '../../../../../core/utils/app_exports.dart';

class SignInSocialButton extends StatelessWidget {
  const SignInSocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final String icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.05),
          borderRadius: 16.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 20.sp, height: 20.sp),
            16.pw,
            Text(
              text,
              style: context.bodyMediumStyle?.copyWith(
                color: AppColors.primaryWhite,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
