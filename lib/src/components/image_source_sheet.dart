import '../core/utils/app_exports.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({
    super.key,
    required this.isDark,
    required this.onPicked,
  });

  final bool isDark;
  final void Function(File?) onPicked;

  static Future<void> show(
    BuildContext context, {
    required bool isDark,
    required void Function(File?) onPicked,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? AppColors.signInDarkBackground
          : AppColors.signInLightBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => ImageSourceSheet(isDark: isDark, onPicked: onPicked),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.primaryWhite : AppColors.signInLightText;
    final tileColor = isDark ? AppColors.signInDarkSurface : AppColors.signInLightSurface;
    final tileBorderColor = isDark
        ? AppColors.signInDarkBorder
        : AppColors.signInLightText.withValues(alpha: 0.1);

    return SafeArea(
      child: Padding(
        padding: AppInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.2),
                borderRadius: 2.circular,
              ),
            ),
            20.ph,
            Text(
              AppStrings.selectImage,
              style: context.titleLargeStyle?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            20.ph,
            _SourceTile(
              icon: Icons.camera_alt_outlined,
              label: AppStrings.camera,
              textColor: textColor,
              tileColor: tileColor,
              borderColor: tileBorderColor,
              onTap: () async {
                Navigator.of(context).pop();
                final file = await AppImagePicker.fromCamera();
                onPicked(file);
              },
            ),
            12.ph,
            _SourceTile(
              icon: Icons.photo_library_outlined,
              label: AppStrings.chooseFromGallery,
              textColor: textColor,
              tileColor: tileColor,
              borderColor: tileBorderColor,
              onTap: () async {
                Navigator.of(context).pop();
                final file = await AppImagePicker.fromGallery();
                onPicked(file);
              },
            ),
            12.ph,
            _SourceTile(
              icon: Icons.close_rounded,
              label: AppStrings.cancel,
              textColor: AppColors.primaryRed,
              tileColor: tileColor,
              borderColor: tileBorderColor,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.tileColor,
    required this.borderColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color textColor;
  final Color tileColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: 14.circular,
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22.sp, color: textColor),
            14.pw,
            Text(
              label,
              style: context.labelLargeStyle?.copyWith(
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
