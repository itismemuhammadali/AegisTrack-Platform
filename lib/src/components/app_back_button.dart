import '../core/utils/app_exports.dart';

/// Circular glass back button — translucent fill, subtle border, chevron
/// icon. Matches the back-button styling used on dark auth screens in
/// Figma (rgba white 5% fill, 10% border, ~18px radius on a 40px box).
/// Defaults to popping the current route so call sites only need to
/// override [onTap] when custom behaviour is required.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? AppRouterGo.back,
      child: Container(
        width: 40.w,
        height: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.05),
          borderRadius: 18.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.primaryWhite,
          size: 16.sp,
        ),
      ),
    );
  }
}
