import '../../../../../core/utils/app_exports.dart';

/// Shared text style for the read-only viewer detail screens.
class TrackerDetailText extends StatelessWidget {
  const TrackerDetailText(
    this.text, {
    super.key,
    this.size = 14,
    this.weight = FontWeight.w400,
    this.color = AppColors.viewerSignInText,
    this.height,
    this.monospace = false,
  });

  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final double? height;
  final bool monospace;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: context.bodyMediumStyle?.copyWith(
          fontSize: size.sp,
          fontWeight: weight,
          color: color,
          height: height ?? 1.2,
          fontFamily: monospace ? 'monospace' : null,
        ),
      );
}
