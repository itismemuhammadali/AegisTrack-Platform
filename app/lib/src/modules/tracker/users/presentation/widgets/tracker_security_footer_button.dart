import '../../../../../core/utils/app_exports.dart';
import 'tracker_detail_text.dart';

class TrackerSecurityFooterButton extends StatelessWidget {
  const TrackerSecurityFooterButton(
    this.label, {
    super.key,
    this.primary = false,
    this.icon,
    this.onTap,
  });

  final String label;
  final bool primary;
  final String? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: 16.circular,
        child: Container(
          padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: primary ? AppColors.trackerPurpleDeep : null,
            borderRadius: 16.circular,
            border:
                primary ? null : Border.all(color: AppColors.trackerBorderSoft),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                SvgPicture.asset(icon!, width: 16.w, height: 16.w),
                8.pw,
              ],
              Flexible(
                child: TrackerDetailText(label,
                    size: 16,
                    weight: FontWeight.w600,
                    color: AppColors.primaryWhite,
                    height: 24 / 16),
              ),
            ],
          ),
        ),
      );
}
