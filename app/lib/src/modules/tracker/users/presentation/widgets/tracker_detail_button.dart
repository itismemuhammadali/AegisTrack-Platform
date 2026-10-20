import '../../../../../core/utils/app_exports.dart';
import 'tracker_detail_text.dart';

class TrackerDetailButton extends StatelessWidget {
  const TrackerDetailButton(
    this.label, {
    super.key,
    this.icon,
    this.primary = false,
    this.onTap,
  });

  final String label;
  final String? icon;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: 20.circular,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 46.h),
          padding: AppInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: primary
                ? AppColors.trackerPurpleDeep
                : AppColors.trackerSurfaceFill,
            borderRadius: 20.circular,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  SvgPicture.asset(icon!, width: 16.w, height: 16.w),
                  8.pw,
                ],
                TrackerDetailText(label, weight: FontWeight.w500),
              ],
            ),
          ),
        ),
      );
}
