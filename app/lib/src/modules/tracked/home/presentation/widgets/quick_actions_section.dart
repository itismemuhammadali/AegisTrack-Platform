import '../../../../../core/utils/app_exports.dart';
import 'quick_action_button.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    this.onLogNow,
    this.onAddNote,
    this.onCapture,
    this.onCheckIn,
  });

  final VoidCallback? onLogNow;
  final VoidCallback? onAddNote;
  final VoidCallback? onCapture;
  final VoidCallback? onCheckIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.quickActions,
          style: context.titleMediumStyle?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryWhite,
          ),
        ),
        10.ph,
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                icon: AppAssetsSvg.trackedHomeQuickActionLogNow,
                label: AppStrings.logNow,
                isPrimary: true,
                onTap: onLogNow,
              ),
            ),
            10.pw,
            Expanded(
              child: QuickActionButton(
                icon: AppAssetsSvg.trackedHomeQuickActionAddNote,
                label: AppStrings.addNote,
                onTap: onAddNote,
              ),
            ),
            10.pw,
            Expanded(
              child: QuickActionButton(
                icon: AppAssetsSvg.trackedHomeQuickActionCapture,
                label: AppStrings.capture,
                onTap: onCapture,
              ),
            ),
            10.pw,
            Expanded(
              child: QuickActionButton(
                icon: AppAssetsSvg.trackedHomeQuickActionCheckIn,
                label: AppStrings.checkIn,
                onTap: onCheckIn,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
