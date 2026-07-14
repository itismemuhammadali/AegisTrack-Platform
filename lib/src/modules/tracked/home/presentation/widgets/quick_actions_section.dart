import '../../../../../core/utils/app_exports.dart';
import 'quick_action_button.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    this.onLogNow,
    this.onAddNote,
    this.onCapture,
  });

  final VoidCallback? onLogNow;
  final VoidCallback? onAddNote;
  final VoidCallback? onCapture;

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
        16.ph,
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
            12.pw,
            Expanded(
              child: QuickActionButton(
                icon: AppAssetsSvg.trackedHomeQuickActionAddNote,
                label: AppStrings.addNote,
                onTap: onAddNote,
              ),
            ),
            12.pw,
            Expanded(
              child: QuickActionButton(
                icon: AppAssetsSvg.trackedHomeQuickActionCapture,
                label: AppStrings.capture,
                onTap: onCapture,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
